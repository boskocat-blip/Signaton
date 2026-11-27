# Signaton LIA - Vecka 4
# Filterdesign: FIR och IIR i R
#
# Samma experiment som notebooks/vecka_04_filterdesign.ipynb och docs/vecka_04_teori.md.
# Kör från projektroten: source("R/vecka_04_filter.R")
# Kräver paketet signal: install.packages("signal")
# Funktionerna anropas som signal::... eftersom paketet annars döljer stats::filter.

fs <- 16000
t <- (0:(fs - 1)) / fs
set.seed(42)   # R och Python har olika slumptal: brusvärdena blir nära men inte identiska

ren_440   <- 0.5 * sin(2 * pi * 440 * t)
brum_50   <- 0.3 * sin(2 * pi * 50 * t)
stor_6000 <- 0.2 * sin(2 * pi * 6000 * t)
brus      <- 0.05 * rnorm(fs)
mix <- ren_440 + brum_50 + stor_6000 + brus

kant <- round(0.1 * fs)        # 0,1 s i varje ände utesluts (filtrens insvängning)
mitt <- (kant + 1):(fs - kant)

snr_db <- function(onskad, total) {
  rest <- total - onskad
  10 * log10(mean(onskad[mitt]^2) / mean(rest[mitt]^2))
}

# Frekvenssvar H(e^{jw}) = B(e^{jw}) / A(e^{jw}), direkt från koefficienterna
svar <- function(b, a, f) {
  sapply(f, function(fk) {
    w <- 2 * pi * fk / fs
    sum(b * exp(-1i * w * (seq_along(b) - 1))) / sum(a * exp(-1i * w * (seq_along(a) - 1)))
  })
}
svar_db <- function(b, a, f) 20 * log10(Mod(svar(b, a, f)))

# Gruppfördröjning i sampel: Re(sum k*b_k*e^{-jwk} / B) - Re(sum k*a_k*e^{-jwk} / A)
grupp <- function(b, a, f) {
  sapply(f, function(fk) {
    w <- 2 * pi * fk / fs
    kb <- seq_along(b) - 1
    ka <- seq_along(a) - 1
    eb <- exp(-1i * w * kb)
    ea <- exp(-1i * w * ka)
    Re(sum(kb * b * eb) / sum(b * eb)) - Re(sum(ka * a * ea) / sum(a * ea))
  })
}

cat("SNR före filtrering:", round(snr_db(ren_440, mix), 2), "dB\n")

# ---------------------------------------------------------------
# 1. Glidande medelvärde (M = 5)
# ---------------------------------------------------------------
M <- 5
b_mv <- rep(1 / M, M)
f_tab <- c(1, 1000, 3200, 6400)
formel <- abs(sin(pi * f_tab * M / fs) / (M * sin(pi * f_tab / fs)))
cat("\n--- Glidande medelvärde, |H| ---\n")
print(data.frame(frekvens_hz = f_tab,
                 H_berakning = round(Mod(svar(b_mv, 1, f_tab)), 4),
                 H_formel = round(formel, 4)), row.names = FALSE)

f <- seq(1, fs / 2, length.out = 4000)
plot(f, pmax(svar_db(b_mv, 1, f), -60), type = "l", col = "blue",
     main = "Glidande medelvärde, M = 5", xlab = "Frekvens (Hz)", ylab = "|H| (dB)")
abline(v = c(3200, 6400), col = "red", lty = 3)

# ---------------------------------------------------------------
# 2. FIR-lågpass med fönstermetoden (101 koefficienter, Hamming)
# ---------------------------------------------------------------
h_fir <- signal::fir1(100, 1000 / (fs / 2), type = "low", window = signal::hamming(101))
h_fir <- as.numeric(h_fir)
stopifnot(isTRUE(all.equal(h_fir, rev(h_fir))))   # symmetrisk -> linjär fas

H_fir <- svar_db(h_fir, 1, f)
cat("\n--- FIR-lågpass ---\n")
cat("Antal koefficienter:", length(h_fir), "\n")
cat("-3 dB vid:", round(f[which(H_fir < -3.0103)[1]], 1), "Hz | -6 dB vid:",
    round(f[which(H_fir < -6.0206)[1]], 1), "Hz\n")
cat("Nivå 440 / 2000 / 6000 Hz:", round(svar_db(h_fir, 1, c(440, 2000, 6000)), 2), "dB\n")
cat("Gruppfördröjning 200 / 440 / 900 Hz:", round(grupp(h_fir, 1, c(200, 440, 900)), 2), "sampel\n")

old_par <- par(mfrow = c(1, 2))
plot(0:100, h_fir, type = "h", main = "Impulssvar h[n]", xlab = "n", ylab = "h[n]")
plot(f, pmax(H_fir, -100), type = "l", col = "blue", main = "FIR, amplitudsvar",
     xlab = "Frekvens (Hz)", ylab = "|H| (dB)")
abline(v = 1000, col = "red", lty = 3)
par(old_par)

# ---------------------------------------------------------------
# 3. IIR-lågpass: Butterworth ordning 4
# ---------------------------------------------------------------
bf <- signal::butter(4, 1000 / (fs / 2), type = "low")
b_iir <- as.numeric(bf$b)
a_iir <- as.numeric(bf$a)

# Poler = rötter till A(z). polyroot vill ha koefficienterna i stigande grad.
poler <- polyroot(rev(a_iir))
cat("\n--- Butterworth, ordning 4 ---\n")
print(data.frame(pol = round(poler, 4), abs_p = round(Mod(poler), 4)), row.names = FALSE)
stopifnot(all(Mod(poler) < 1))   # stabilt

ordning_tabell <- do.call(rbind, lapply(c(2, 4, 8), function(n) {
  bn <- signal::butter(n, 1000 / (fs / 2), type = "low")
  db <- svar_db(as.numeric(bn$b), as.numeric(bn$a), c(1000, 2000, 4000))
  data.frame(ordning = n, db_1000 = round(db[1], 2), db_2000 = round(db[2], 1), db_4000 = round(db[3], 1))
}))
cat("\nOrdningens betydelse:\n")
print(ordning_tabell, row.names = FALSE)

H_iir <- svar_db(b_iir, a_iir, f)
f_gd <- f[f < 4000]
plot(f, pmax(H_fir, -100), type = "l", col = "blue", xlim = c(0, 4000), ylim = c(-100, 5),
     main = "FIR och Butterworth", xlab = "Frekvens (Hz)", ylab = "|H| (dB)")
lines(f, H_iir, col = "orange", lwd = 2)
abline(v = 1000, col = "red", lty = 3)
legend("topright", c("FIR, 101 koeff.", "Butterworth, ordning 4"), col = c("blue", "orange"), lty = 1, cex = 0.8)

plot(f_gd, grupp(b_iir, a_iir, f_gd), type = "l", col = "orange", ylim = c(0, 55),
     main = "Gruppfördröjning", xlab = "Frekvens (Hz)", ylab = "Sampel")
abline(h = 50, col = "blue", lty = 2)

# ---------------------------------------------------------------
# 4. Jämförelse FIR och IIR
# ---------------------------------------------------------------
jamforelse <- data.frame(
  egenskap = c("Koefficienter (b + a)", "Niva 1000 Hz (dB)", "Dampning 2000 Hz (dB)",
               "Dampning 6000 Hz (dB)", "Gruppfordrojning 440 Hz (sampel)"),
  FIR = c(length(h_fir), round(svar_db(h_fir, 1, c(1000, 2000, 6000)), 1), round(grupp(h_fir, 1, 440), 2)),
  IIR = c(length(b_iir) + length(a_iir), round(svar_db(b_iir, a_iir, c(1000, 2000, 6000)), 1),
          round(grupp(b_iir, a_iir, 440), 2))
)
cat("\n--- Jämförelse ---\n")
print(jamforelse, row.names = FALSE)

# ---------------------------------------------------------------
# 5. Bandpass 300-3400 Hz med nollfas (filtfilt)
# ---------------------------------------------------------------
bp <- signal::butter(4, c(300, 3400) / (fs / 2), type = "pass")
bp_filtfilt <- function(x) as.numeric(signal::filtfilt(as.numeric(bp$b), as.numeric(bp$a), x))
filtrerad <- bp_filtfilt(mix)

rms_db <- function(x) 10 * log10(mean(x[mitt]^2))
komponenter <- list("440 Hz (onskad)" = ren_440, "Brum 50 Hz" = brum_50,
                    "Storton 6000 Hz" = stor_6000, "Vitt brus" = brus)
komponent_tabell <- do.call(rbind, lapply(names(komponenter), function(namn) {
  k <- komponenter[[namn]]
  ut <- bp_filtfilt(k)
  data.frame(komponent = namn, fore_db = round(rms_db(k), 1), efter_db = round(rms_db(ut), 1),
             andring_db = round(rms_db(ut) - rms_db(k), 1))
}))
cat("\n--- Bandpass 300-3400 Hz ---\n")
print(komponent_tabell, row.names = FALSE)

snr_fore <- snr_db(ren_440, mix)
snr_efter <- snr_db(bp_filtfilt(ren_440), filtrerad)
cat("SNR före:", round(snr_fore, 2), "dB | SNR efter:", round(snr_efter, 2),
    "dB | förbättring:", round(snr_efter - snr_fore, 1), "dB\n")

# Amplitudspektrum före och efter (1 s signal -> 1 Hz upplösning)
spek <- function(x) 20 * log10(Mod(fft(x))[1:(fs / 2 + 1)] * 2 / fs + 1e-12)
fr <- 0:(fs / 2)
plot(fr[-1], spek(mix)[-1], type = "l", log = "x", col = "gray50", ylim = c(-160, 0),
     main = "Spektrum före och efter bandpass", xlab = "Frekvens (Hz, log)", ylab = "dB")
lines(fr[-1], spek(filtrerad)[-1], col = "orange")
legend("bottomleft", c("Före", "Efter"), col = c("gray50", "orange"), lty = 1, cex = 0.8)

n_visa <- round(0.04 * fs)
idx <- 4001:(4000 + n_visa)
plot(1000 * (0:(n_visa - 1)) / fs, mix[idx], type = "l", col = "gray80",
     main = "Tidsdomän, 40 ms", xlab = "Tid (ms)", ylab = "Amplitud")
lines(1000 * (0:(n_visa - 1)) / fs, ren_440[idx], col = "blue", lty = 2)
lines(1000 * (0:(n_visa - 1)) / fs, filtrerad[idx], col = "orange", lwd = 2)
legend("topright", c("Före", "Ren 440 Hz", "Efter bandpass"),
       col = c("gray80", "blue", "orange"), lty = c(1, 2, 1), cex = 0.8)

stopifnot(snr_efter - snr_fore > 15)
