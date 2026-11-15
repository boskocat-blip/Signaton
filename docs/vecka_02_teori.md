# Vecka 2 — Teori och förväntade resultat

Teorin hör ihop med `notebooks/vecka_02_sampling_kvantisering_aliasing.ipynb` och `R/vecka_02_sampling.R`. Alla tre använder samma parametrar: 440 Hz sinus, amplitud 0,8, `fs = 16000` Hz, 1 sekund.

## Sampling

En kontinuerlig signal representeras som diskreta mätvärden. Vid `fs = 16000` Hz registreras 16 000 sampel per sekund, vilket ger cirka 36 sampel per period för en 440 Hz-ton. Vid 2 000 Hz blir det cirka 4,5 sampel per period och vid 600 Hz färre än 2.

## Nyquist och aliasing

För en bandbegränsad signal krävs en samplingsfrekvens högre än dubbla högsta frekvensen, `fs > 2·f_max`, för entydig rekonstruktion. Frekvenser över Nyquistgränsen `fs/2` viks ned till

```
f_alias = |f − k·fs|,  där k väljs så att 0 ≤ f_alias ≤ fs/2
```

| Signal | fs | Nyquistgräns | Observerad frekvens |
|---|---|---|---|
| 440 Hz | 16 000 Hz | 8 000 Hz | 440 Hz (korrekt) |
| 440 Hz | 2 000 Hz | 1 000 Hz | 440 Hz (korrekt) |
| 440 Hz | 600 Hz | 300 Hz | **160 Hz** (alias) |
| 1 200 Hz | 8 000 Hz | 4 000 Hz | 1 200 Hz (korrekt) |
| 1 200 Hz | 2 000 Hz | 1 000 Hz | **800 Hz** (alias) |

I praktiken används ett analogt antialiasfilter före sampling, eftersom aliasing inte kan tas bort i efterhand.

## Kvantisering

Amplituden avrundas till ett ändligt antal nivåer, `2^b` för `b` bitar. Fler bitar minskar kvantiseringsfelet.

- **MSE** mäter medelkvadratfelet mellan original och kvantiserad signal.
- **SQNR** = `10·log10(medel(x²) / MSE)` dB mäter signalenergi relativt kvantiseringsbrus.
- Tumregel: SQNR ökar med cirka 6 dB per bit. För en sinus med amplitud *A*: `SQNR ≈ 6,02·b + 1,76 + 20·log10(A)` dB. Approximationen gäller när antalet nivåer är stort och stämmer sämre vid 2 bitar.

Förväntade värden för A = 0,8: cirka 24 dB vid 4 bitar, 48 dB vid 8 bitar och 96 dB vid 16 bitar.

## Data capture

Kontrollera samplingsfrekvens, antal kanaler, bitdjup, längd, amplitud och eventuell klippning. Här används den syntetiska filen `data/test_signal_440hz.wav` (16 kHz, mono, 16-bit PCM, 1 s, peak 0,8) i stället för inspelat tal. Filen skapas av notebooken och läses sedan i både Python och R.
