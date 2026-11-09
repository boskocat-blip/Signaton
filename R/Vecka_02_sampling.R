# Signaton LIA - Vecka 2
# Sampling, kvantisering och aliasing

# 1. Generera en sinussignal
fs <- 16000
frequency <- 440
duration <- 0.02

t <- seq(0, duration - 1/fs, by = 1/fs)
signal <- sin(2 * pi * frequency * t)

# Visualisera signalen
plot(
  t, signal,
  type = "l",
  col = "blue",
  lwd = 2,
  main = "Sampling av en 440 Hz sinussignal",
  xlab = "Tid (sekunder)",
  ylab = "Amplitud"
)

# 2. Kvantisering
quantize <- function(x, bits) {
  levels <- 2^bits
  q <- round((x + 1) / 2 * (levels - 1))
  return(q / (levels - 1) * 2 - 1)
}

# Beräkna kvantiseringsfel
for (bits in c(4, 8, 16)) {
  quantized <- quantize(signal, bits)
  mse <- mean((signal - quantized)^2)

  cat(bits, "bitar - MSE:", mse, "\n")
}

# 3. Aliasing
fs_low <- 600

t_low <- seq(0, duration - 1/fs_low, by = 1/fs_low)
signal_low <- sin(2 * pi * frequency * t_low)

plot(
  t_low, signal_low,
  type = "b",
  col = "red",
  main = "Aliasing vid 600 Hz sampling",
  xlab = "Tid (sekunder)",
  ylab = "Amplitud"
)

# 4. Data capture - läsa WAV-fil i R

library(tuneR)

wav_files <- list.files(
  ".",
  pattern = "^test_signal_440hz\\.wav$",
  recursive = TRUE,
  full.names = TRUE
)

if (length(wav_files) == 0) {
  stop("WAV-filen hittades inte.")
}

wav_path <- wav_files[1]

# Läs in ljudfilen
audio <- readWave(wav_path)

# Visa information om ljudfilen
cat("\n--- WAV-information ---\n")
cat("Samplingsfrekvens:", audio@samp.rate, "Hz\n")
cat("Bitdjup:", audio@bit, "bitar\n")
cat("Antal sampel:", length(audio@left), "\n")
cat("Längd:", length(audio@left) / audio@samp.rate, "sekunder\n")

# Visualisera de första 20 millisekunderna
samples <- round(0.02 * audio@samp.rate)

t_audio <- (0:(samples - 1)) / audio@samp.rate

plot(
  t_audio,
  audio@left[1:samples],
  type = "l",
  col = "blue",
  lwd = 2,
  main = "Inläst WAV-signal i R",
  xlab = "Tid (sekunder)",
  ylab = "Amplitud (PCM)"
)