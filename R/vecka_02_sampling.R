# Signaton LIA - Vecka 2
# Sampling, aliasing, kvantisering och data capture i R
#
# Samma parametrar och experiment som
# notebooks/vecka_02_sampling_kvantisering_aliasing.ipynb och docs/vecka_02_teori.md.
# Kör från projektroten: source("R/vecka_02_sampling.R")
# WAV-filen skapas av notebooken - kör den först.

fs        <- 16000   # samplingsfrekvens (Hz)
f_signal  <- 440     # signalfrekvens (Hz)
amplitud  <- 0.8
duration  <- 1.0     # sekunder

t <- (0:(fs * duration - 1)) / fs
signal <- amplitud * sin(2 * pi * f_signal * t)
cat("Antal sampel:", length(signal), "| fs:", fs, "Hz\n")

# ---------------------------------------------------------------
# 1. Sampling - 440 Hz vid 16 000, 2 000 och 600 Hz (20 ms)
# ---------------------------------------------------------------
fonster <- 0.02
t_tat <- seq(0, fonster, by = 1 / 200000)

old_par <- par(mfrow = c(3, 1), mar = c(4, 4, 2, 1))
for (fs_test in c(16000, 2000, 600)) {
  ts <- (0:(fonster * fs_test - 1)) / fs_test
  xs <- amplitud * sin(2 * pi * f_signal * ts)
  plot(t_tat, amplitud * sin(2 * pi * f_signal * t_tat), type = "l", col = "gray80",
       main = paste0("440 Hz samplad vid ", fs_test, " Hz (", length(ts), " sampel)"),
       xlab = "Tid (s)", ylab = "Amplitud")
  lines(ts, xs, type = "b", pch = 20, col = "blue")
}
par(old_par)

# ---------------------------------------------------------------
# 2. Aliasing - förväntad frekvens jämfört med FFT-topp
# ---------------------------------------------------------------
forvantad_frekvens <- function(f, fs) {
  f_mod <- f %% fs
  min(f_mod, fs - f_mod)
}

toppfrekvens <- function(x, fs) {
  n <- length(x)
  halva <- floor(n / 2)
  amp <- Mod(fft(x))[1:(halva + 1)]
  freqs <- (0:halva) * fs / n
  freqs[which.max(amp[-1]) + 1]   # DC exkluderas
}

fall <- data.frame(signal_hz = c(440, 440, 440, 1200, 1200),
                   fs_hz     = c(16000, 2000, 600, 8000, 2000))
fall$nyquist_uppfyllt <- fall$fs_hz > 2 * fall$signal_hz
fall$forvantad_hz <- mapply(forvantad_frekvens, fall$signal_hz, fall$fs_hz)
fall$uppmatt_hz <- mapply(function(f, fs_test) {
  n <- 0:(fs_test - 1)                       # 1 sekund
  toppfrekvens(sin(2 * pi * f * n / fs_test), fs_test)
}, fall$signal_hz, fall$fs_hz)

cat("\n--- Aliasing ---\n")
print(fall, row.names = FALSE)
stopifnot(all(fall$uppmatt_hz == fall$forvantad_hz))

# 440 Hz vid 600 Hz ger samma sampel som en 160 Hz-sinus med omvänt tecken
fs_lag <- 600
n <- 0:(fonster * fs_lag - 1)
sampel <- sin(2 * pi * f_signal * n / fs_lag)
stopifnot(isTRUE(all.equal(sampel, -sin(2 * pi * 160 * n / fs_lag))))

plot(t_tat, sin(2 * pi * f_signal * t_tat), type = "l", col = "gray80",
     main = "Aliasing: 440 Hz samplad vid 600 Hz uppfattas som 160 Hz",
     xlab = "Tid (s)", ylab = "Amplitud")
lines(t_tat, -sin(2 * pi * 160 * t_tat), col = "red", lty = 2)
points(n / fs_lag, sampel, pch = 19)
legend("topright", legend = c("Original 440 Hz", "Alias 160 Hz", "Sampel vid 600 Hz"),
       col = c("gray80", "red", "black"), lty = c(1, 2, NA), pch = c(NA, NA, 19), cex = 0.8)

# ---------------------------------------------------------------
# 3. Kvantisering - 2, 4, 8 och 16 bitar
# ---------------------------------------------------------------
kvantisera <- function(x, bits) {
  nivaer <- 2^bits
  round((pmin(1, pmax(-1, x)) + 1) * (nivaer - 1) / 2) * 2 / (nivaer - 1) - 1
}

kvant <- data.frame(bitar = c(2, 4, 8, 16))
kvant$nivaer <- 2^kvant$bitar
kvant$mse <- sapply(kvant$bitar, function(b) mean((signal - kvantisera(signal, b))^2))
kvant$sqnr_db <- round(10 * log10(mean(signal^2) / kvant$mse), 2)
kvant$sqnr_teori_db <- round(6.02 * kvant$bitar + 1.76 + 20 * log10(amplitud), 2)
kvant$mse <- signif(kvant$mse, 4)

cat("\n--- Kvantisering ---\n")
print(kvant, row.names = FALSE)

# ---------------------------------------------------------------
# 4. Data capture - läsa WAV-filen som notebooken skapat
# ---------------------------------------------------------------
library(tuneR)

wav_path <- file.path("data", "test_signal_440hz.wav")
if (!file.exists(wav_path)) {
  stop("Hittar inte ", wav_path, ". Kör vecka 2-notebooken först och kör skriptet från projektroten.")
}

audio <- readWave(wav_path)
normaliserad <- audio@left / 32768

cat("\n--- WAV-kontroll ---\n")
cat("Fil:", wav_path, "\n")
cat("Samplingsfrekvens:", audio@samp.rate, "Hz\n")
cat("Kanaler:", ifelse(audio@stereo, 2, 1), "\n")
cat("Bitdjup:", audio@bit, "bitar\n")
cat("Antal sampel:", length(audio@left), "\n")
cat("Längd:", length(audio@left) / audio@samp.rate, "sekunder\n")
cat("Peak:", round(max(abs(normaliserad)), 4), "\n")
cat("RMS:", round(sqrt(mean(normaliserad^2)), 4), "\n")
cat("Klippta sampel:", sum(abs(audio@left) >= 32767), "\n")

stopifnot(audio@samp.rate == fs, !audio@stereo, audio@bit == 16,
          length(audio@left) == length(signal))

antal <- round(0.02 * audio@samp.rate)
plot((0:(antal - 1)) / audio@samp.rate, normaliserad[1:antal], type = "l", col = "blue",
     main = "Inläst WAV-signal i R - första 20 ms",
     xlab = "Tid (s)", ylab = "Amplitud")
