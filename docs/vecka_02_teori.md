# Vecka 2 — Teori och förväntade resultat

**Sampling:** en kontinuerlig signal representeras som diskreta mätvärden. Vid `fs=16000` Hz registreras 16 000 sampel per sekund.

**Nyquist:** för en bandbegränsad signal krävs en samplingsfrekvens högre än dubbla högsta frekvensen för entydig rekonstruktion. I praktiken används antialiasfilter.

**Kvantisering:** amplitud avrundas till ett ändligt antal nivåer. Fler bitar minskar normalt kvantiseringsfelet. MSE mäter medelkvadratfelet, SQNR signalenergi relativt kvantiseringsbrus.

**Aliasing:** vid 1 200 Hz ton och 2 000 Hz sampling uppträder en 800 Hz-komponent i den diskreta signalen.

**Data capture:** kontrollera samplingsfrekvens, antal kanaler, bitdjup, längd, amplitud och eventuella klippningar. Syntetiska WAV-filer används här i stället för inspelat tal.

## Frågor att besvara
- Vad skiljer samplingsfrekvens från bitdjup?
- Hur ser skillnaden mellan 2 och 16 bitar ut?
- Varför kan inte ett digitalt filter i efterhand entydigt återställa redan aliaserad information?
- Vilka metadata bör dokumenteras vid inspelning?
