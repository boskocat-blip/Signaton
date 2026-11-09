# Vecka 2: sampling, kvantisering och aliasing i base R
fs <- 16000; t <- (0:(fs-1))/fs; x <- 0.8*sin(2*pi*440*t)
quantize <- function(x, bits) { levels <- 2^bits; round((pmin(1,pmax(-1,x))+1)*(levels-1)/2)*2/(levels-1)-1 }
for (bits in c(2,4,8,16)) { q <- quantize(x,bits); mse <- mean((x-q)^2); cat(bits,'bit MSE:',mse,'SQNR:',10*log10(mean(x^2)/mse),'dB\n') }
peak_frequency <- function(freq, fs) { tt <- (0:(fs-1))/fs; y <- sin(2*pi*freq*tt); amps <- Mod(fft(y))[1:(fs/2+1)]; (which.max(amps[-1]))*fs/fs }
cat('1200 Hz vid fs=2000 ->',peak_frequency(1200,2000),'Hz\n')
cat('1200 Hz vid fs=8000 ->',peak_frequency(1200,8000),'Hz\n')
stopifnot(peak_frequency(1200,2000)==800)
plot(t[1:160],x[1:160],type='l',xlab='Tid (s)',ylab='Amplitud',main='440 Hz signal')
# WAV-inlasning i R kan goras med paketet tuneR: install.packages('tuneR'); tuneR::readWave('data/demo_440hz.wav')
