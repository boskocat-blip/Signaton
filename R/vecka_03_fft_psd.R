# Signaton LIA - Vecka 3
# FFT, fönsterfunktioner och PSD i R
#
# Samma parametrar och experiment som
# notebooks/vecka_03_fft_fonster_psd.ipynb och docs/vecka_03_teori.md.
# Kör från projektroten: source("R/vecka_03_fft_psd.R")
# Kräver paketet ggplot2 (install.packages("ggplot2")) och tuneR för WAV-delen.

library(ggplot2)

fs        <- 16000
f_signal  <- 440
amplitud  <- 0.8
duration  <- 1.0

t <- (0:(fs * duration - 1)) / fs
signal <- amplitud * sin(2 * pi * f_signal * t)

# Ensidigt amplitudspektrum, skalat så att en sinus med amplitud A ger toppen A
amplitudspektrum <- function(x, fs, w = rep(1, length(x))) {
  n <- length(x)
  halva <- floor(n / 2)
  X <- fft(x * w)
  amp <- Mod(X[1:(halva + 1)]) * 2 / sum(w)
  amp[1] <- amp[1] / 2
  data.frame(f = (0:halva) * fs / n, amp = amp)
}

# ---------------------------------------------------------------
# 1. FFT och frekvensupplösning
# ---------------------------------------------------------------
fft_tabell <- do.call(rbind, lapply(c(16000, 1024, 256), function(n) {
  s <- amplitudspektrum(signal[1:n], fs)
  k <- which.max(s$amp)
  data.frame(N = n, langd_ms = 1000 * n / fs, delta_f_hz = fs / n,
             topp_hz = s$f[k], toppamplitud = round(s$amp[k], 3))
}))
cat("--- FFT och frekvensupplösning ---\n")
print(fft_tabell, row.names = FALSE)

hel <- amplitudspektrum(signal, fs)
stopifnot(hel$f[which.max(hel$amp)] == 440, abs(max(hel$amp) - amplitud) < 1e-9)
plot(hel$f, hel$amp, type = "l", xlim = c(0, 2000), col = "blue",
     main = "Amplitudspektrum, N = 16 000", xlab = "Frekvens (Hz)", ylab = "Amplitud")

# ---------------------------------------------------------------
# 2. Spektralt läckage (N = 1 024, rektangulärt fönster)
# ---------------------------------------------------------------
N <- 1024
tn <- (0:(N - 1)) / fs
pa_bin  <- amplitudspektrum(amplitud * sin(2 * pi * 437.5 * tn), fs)
av_bin  <- amplitudspektrum(amplitud * sin(2 * pi * 440 * tn), fs)
cat("\n--- Läckage ---\n")
cat("437,5 Hz (bin 28,00): topp", round(max(pa_bin$amp), 3), "\n")
cat("440,0 Hz (bin 28,16): topp", round(max(av_bin$amp), 3), "\n")

plot(pa_bin$f, 20 * log10(pmax(pa_bin$amp, 1e-12)), type = "b", pch = 20, cex = 0.5,
     xlim = c(0, 2000), ylim = c(-120, 5), col = "blue",
     main = "Läckage med rektangulärt fönster, N = 1 024",
     xlab = "Frekvens (Hz)", ylab = "Amplitud (dB)")
lines(av_bin$f, 20 * log10(pmax(av_bin$amp, 1e-12)), type = "b", pch = 20, cex = 0.5, col = "red")
legend("topright", legend = c("437,5 Hz (på bin)", "440 Hz (mellan binar)"),
       col = c("blue", "red"), lty = 1, cex = 0.8)

# ---------------------------------------------------------------
# 3. Fönsterfunktioner (periodiska, samma som scipy.signal.get_window)
# ---------------------------------------------------------------
fonsterfunktion <- function(namn, n) {
  k <- 0:(n - 1)
  switch(namn,
         "Rektangulärt" = rep(1, n),
         "Hann"         = 0.5 - 0.5 * cos(2 * pi * k / n),
         "Hamming"      = 0.54 - 0.46 * cos(2 * pi * k / n),
         "Blackman"     = 0.42 - 0.5 * cos(2 * pi * k / n) + 0.08 * cos(4 * pi * k / n))
}
fonster_namn <- c("Rektangulärt", "Hann", "Hamming", "Blackman")

fonster_db <- function(w, pad = 64) {
  n <- length(w)
  W <- Mod(fft(c(w, rep(0, n * (pad - 1)))))[1:(n * pad / 2)]
  20 * log10(W / max(W) + 1e-300)
}

fonstermatt <- function(w, pad = 64) {
  n <- length(w)
  W_db <- fonster_db(w, pad)
  i <- 2
  while (W_db[i + 1] < W_db[i]) i <- i + 1     # första nollstället
  data.frame(
    koherent_forstarkning = round(mean(w), 3),
    enbw_bin              = round(n * sum(w^2) / sum(w)^2, 3),
    hogsta_sidlob_db      = round(max(W_db[i:length(W_db)]), 1),
    bredd_3db_bin         = round(2 * (which(W_db < -3.0103)[1] - 1) / pad, 2),
    huvudlob_bin          = round(2 * (i - 1) / pad, 1)
  )
}

fonster_tabell <- do.call(rbind, lapply(fonster_namn, function(namn) {
  cbind(fonster = namn, fonstermatt(fonsterfunktion(namn, N)))
}))
cat("\n--- Fönstermått ---\n")
print(fonster_tabell, row.names = FALSE)

# Fönstrens spektrum (ggplot2)
pad <- 64
fonster_spektrum <- do.call(rbind, lapply(fonster_namn, function(namn) {
  W_db <- fonster_db(fonsterfunktion(namn, N), pad)
  bins <- (0:(length(W_db) - 1)) / pad
  keep <- bins <= 20
  data.frame(fonster = namn, bin = bins[keep], db = W_db[keep])
}))
print(
  ggplot(fonster_spektrum, aes(bin, db, colour = fonster)) +
    geom_line() +
    coord_cartesian(ylim = c(-120, 5)) +
    labs(title = "Fönstrets spektrum (N = 1 024)", x = "Avstånd från toppen (bin)",
         y = "dB", colour = "Fönster") +
    theme_minimal()
)

# Svag ton (1 000 Hz, -40 dB) bredvid stark ton (440 Hz)
f_svag <- 1000
a_svag <- 0.008
x_tva <- amplitud * sin(2 * pi * f_signal * tn) + a_svag * sin(2 * pi * f_svag * tn)
k_svag <- round(f_svag / (fs / N)) + 1        # R-index (bin 64 -> element 65)
k_440  <- round(f_signal / (fs / N)) + 1

svag_ton <- do.call(rbind, lapply(fonster_namn, function(namn) {
  s <- amplitudspektrum(x_tva, fs, fonsterfunktion(namn, N))
  db <- 20 * log10(pmax(s$amp, 1e-12))
  framtradande <- db[k_svag] - 0.5 * (db[k_svag - 4] + db[k_svag + 4])
  data.frame(fonster = namn,
             topp_440 = round(s$amp[k_440], 3),
             niva_1000_db = round(db[k_svag], 1),
             framtradande_db = round(framtradande, 1),
             svag_ton_syns = framtradande > 6)
}))
cat("\n--- Svag ton vid 1 000 Hz ---\n")
print(svag_ton, row.names = FALSE)
stopifnot(!svag_ton$svag_ton_syns[1], all(svag_ton$svag_ton_syns[-1]))

# ---------------------------------------------------------------
# 4. PSD: periodogram och Welch
# ---------------------------------------------------------------
# Ensidig PSD-skattning från ett segment (samma skalning som scipy.signal)
psd_segment <- function(x, fs, w) {
  n <- length(x)
  x <- x - mean(x)                              # detrend = "constant"
  halva <- floor(n / 2)
  P <- Mod(fft(x * w)[1:(halva + 1)])^2 / (fs * sum(w^2))
  inre <- if (n %% 2 == 0) 2:halva else 2:(halva + 1)
  P[inre] <- 2 * P[inre]
  P
}

periodogram_psd <- function(x, fs) {
  n <- length(x)
  data.frame(f = (0:floor(n / 2)) * fs / n, P = psd_segment(x, fs, rep(1, n)))
}

welch_psd <- function(x, fs, nperseg = 1024, noverlap = 512) {
  w <- fonsterfunktion("Hann", nperseg)
  starter <- seq(1, length(x) - nperseg + 1, by = nperseg - noverlap)
  P <- rowMeans(sapply(starter, function(s) psd_segment(x[s:(s + nperseg - 1)], fs, w)))
  data.frame(f = (0:(nperseg / 2)) * fs / nperseg, P = P)
}

snr_fran_psd <- function(psd, f0 = f_signal, bredd = 50) {
  df <- psd$f[2] - psd$f[1]
  signalband <- abs(psd$f - f0) <= bredd
  brustathet <- mean(psd$P[!signalband & psd$f > 0])
  p_signal <- sum(psd$P[signalband]) * df - brustathet * sum(signalband) * df
  10 * log10(p_signal / (brustathet * fs / 2))
}

set.seed(42)   # R och Python har olika slumptalsgeneratorer: siffrorna blir nära men inte identiska
x_brus <- signal + 0.1 * rnorm(length(signal))

per <- periodogram_psd(x_brus, fs)
wel <- welch_psd(x_brus, fs)

psd_rad <- function(namn, psd) {
  df <- psd$f[2] - psd$f[1]
  b <- psd$f > 1000 & psd$f < 7000
  data.frame(metod = namn, delta_f_hz = df,
             parseval_area = round(sum(psd$P) * df, 4),
             brusgolv_medel = signif(mean(psd$P[b]), 4),
             brusgolv_std = signif(sd(psd$P[b]), 4),
             topp_hz = psd$f[which.max(psd$P)],
             snr_db = round(snr_fran_psd(psd), 2))
}
cat("\n--- PSD ---\n")
cat("Medeleffekt i tidsdomän:", round(mean(x_brus^2), 4), "| teoretiskt brusgolv: 1.25e-06\n")
print(rbind(psd_rad("Periodogram", per), psd_rad("Welch", wel)), row.names = FALSE)

psd_lang <- rbind(data.frame(metod = "Periodogram (Δf = 1 Hz)", per),
                  data.frame(metod = "Welch (Δf = 15,6 Hz)", wel))
print(
  ggplot(psd_lang, aes(f, 10 * log10(P), colour = metod)) +
    geom_line(aes(linewidth = metod, alpha = metod)) +
    scale_linewidth_manual(values = c(0.3, 1)) +
    scale_alpha_manual(values = c(0.5, 1)) +
    geom_hline(yintercept = 10 * log10(0.01 / (fs / 2)), linetype = "dashed") +
    coord_cartesian(ylim = c(-100, 0)) +
    labs(title = "PSD: 440 Hz + vitt brus (σ = 0,1)", x = "Frekvens (Hz)",
         y = "PSD (dB, amplitud²/Hz)", colour = "Metod") +
    guides(linewidth = "none", alpha = "none") +
    theme_minimal()
)

# ---------------------------------------------------------------
# 5. WAV-filen från vecka 2
# ---------------------------------------------------------------
library(tuneR)
wav_path <- file.path("data", "test_signal_440hz.wav")
if (!file.exists(wav_path)) {
  stop("Hittar inte ", wav_path, ". Kör vecka 2- eller vecka 3-notebooken först och kör skriptet från projektroten.")
}
audio <- readWave(wav_path)
x_wav <- audio@left / 32768
s_wav <- amplitudspektrum(x_wav, audio@samp.rate, fonsterfunktion("Hann", length(x_wav)))
w_wav <- welch_psd(x_wav, audio@samp.rate)

cat("\n--- WAV-filen ---\n")
cat("Toppfrekvens, FFT med Hann:", s_wav$f[which.max(s_wav$amp)], "Hz\n")
cat("Toppamplitud:", round(max(s_wav$amp), 4), "\n")
cat("Toppfrekvens, Welch:", w_wav$f[which.max(w_wav$P)], "Hz\n")
cat("Parseval: PSD-area", round(sum(w_wav$P) * (w_wav$f[2] - w_wav$f[1]), 4),
    "| medeleffekt", round(mean(x_wav^2), 4), "\n")
stopifnot(s_wav$f[which.max(s_wav$amp)] == 440)
