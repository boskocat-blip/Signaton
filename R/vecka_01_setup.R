# Signaton LIA - Vecka 1
# Kontroll av R-miljon

cat("Signaton LIA - Vecka 1\n")

# Kontrollera R-version
print(R.version.string)

# Skapa en enkel dataserie
signal <- c(1, 2, 3, 4, 5)

# Berakna medelvarde
medelvarde <- mean(signal)

cat("Medelvarde:", medelvarde, "\n")

# Visa enkel grafik
plot(
  signal,
  type = "b",
  col = "blue",
  main = "Signaton - Testsignal",
  xlab = "Sample",
  ylab = "Amplitude"
)

cat("R environment ready!\n")