# Vecka 3 — Teori och förväntade resultat: FFT, fönsterfunktioner och PSD

Teorin hör ihop med `notebooks/vecka_03_fft_fonster_psd.ipynb` och `R/vecka_03_fft_psd.R`. Parametrarna är desamma som i vecka 2: 440 Hz sinus, amplitud 0,8, `fs = 16000` Hz.

## DFT och FFT

Den diskreta Fouriertransformen av *N* sampel är

```
X[k] = Σ x[n] · e^(−j·2π·k·n/N),   k = 0 … N−1
```

FFT är en snabb algoritm för att beräkna DFT (O(N log N) i stället för O(N²)). Bin *k* motsvarar frekvensen `k · fs / N`.

- **Frekvensupplösning:** `Δf = fs / N`. Den bestäms av analysfönstrets längd i tid (`N / fs` sekunder). Zero-padding ger fler punkter i spektret (interpolation) men inte bättre förmåga att skilja två närliggande toner.
- **Ensidigt spektrum:** för reella signaler är spektret symmetriskt, så frekvenserna 0 … fs/2 räcker.
- **Amplitudskalning:** `|X[k]| · 2 / N` ger sinusens amplitud (DC skalas med `1 / N`). Med fönster *w* används `2 / Σw` (koherent förstärkning).

| N | Längd | Δf | Förväntad topp för 440 Hz |
|---|---|---|---|
| 16 000 | 1 s | 1 Hz | 440 Hz, amplitud 0,8 |
| 1 024 | 64 ms | 15,625 Hz | 437,5 Hz (närmaste bin), amplitud < 0,8 |
| 256 | 16 ms | 62,5 Hz | 437,5 Hz (närmaste bin) |

## Spektralt läckage

FFT:n behandlar analysfönstret som om det upprepades periodiskt. Om fönstret inte innehåller ett helt antal perioder uppstår ett hopp i kanterna, och energin sprids ut över många binar (*läckage*). Toppen blir också lägre när frekvensen hamnar mellan två binar (*scalloping loss*).

- 437,5 Hz med N = 1 024 → exakt bin 28 → inget läckage.
- 440 Hz med N = 1 024 → bin 28,16 → läckage, toppen sjunker till cirka 0,77.

## Fönsterfunktioner

Ett fönster tonar ned signalen mot kanterna, vilket minskar läckaget (lägre sidlober) men breddar huvudloben (sämre upplösning). Periodiska fönster, `n = 0 … N−1`:

| Fönster | Formel | Koherent förstärkning | ENBW (bin) | Högsta sidlob | Huvudlob (bin) |
|---|---|---|---|---|---|
| Rektangulärt | 1 | 1,00 | 1,00 | −13 dB | 2 |
| Hann | 0,5 − 0,5·cos(2πn/N) | 0,50 | 1,50 | −31 dB | 4 |
| Hamming | 0,54 − 0,46·cos(2πn/N) | 0,54 | 1,36 | −43 dB | 4 |
| Blackman | 0,42 − 0,5·cos(2πn/N) + 0,08·cos(4πn/N) | 0,42 | 1,73 | −58 dB | 6 |

- **Koherent förstärkning** = fönstrets medelvärde. Den korrigeras bort i amplitudskalningen.
- **ENBW** (ekvivalent brusbandbredd) = `N·Σw² / (Σw)²`. Den behövs när brus mäts med fönster.
- **Avvägning:** rektangulärt fönster ger skarpast topp men mest läckage. Blackman ger minst läckage men bredast topp. Hann är en bra kompromiss och standardval för ljud.

**Förväntat i experimentet med svag ton** (440 Hz med amplitud 0,8 och 1 000 Hz med amplitud 0,008, alltså −40 dB, N = 1 024): det rektangulära fönstrets läckage från 440 Hz ligger runt −47 dB vid 1 000 Hz och döljer tonen. Med Hann, Hamming och Blackman syns tonen som en tydlig topp.

## Effektspektraltäthet (PSD)

PSD beskriver hur signalens effekt fördelas över frekvens (enhet amplitud²/Hz). Ensidig skattning från ett segment med fönster *w*:

```
P[k] = 2 · |X[k]|² / (fs · Σw²)    (faktorn 2 gäller inte DC och Nyquist)
```

- **Periodogram:** en FFT över hela signalen. Fin upplösning men stor varians: brusgolvets spridning är lika stor som dess medelvärde, oavsett signalens längd.
- **Welch:** dela signalen i överlappande segment (här Hann, 1 024 sampel, 50 % överlapp), beräkna periodogrammet för varje segment och ta medelvärdet. Variansen minskar ungefär i proportion till antalet segment, och priset är grövre upplösning (`Δf = fs / nperseg`).
- **Parseval:** `Σ P[k] · Δf` = signalens medeleffekt.

**Förväntat för 440 Hz (amplitud 0,8) och vitt brus med σ = 0,1:**

| Storhet | Teoretiskt värde |
|---|---|
| Sinusens effekt | 0,8² / 2 = 0,32 |
| Brusets effekt | σ² = 0,01 |
| Total medeleffekt (Parseval) | 0,33 |
| Brusgolv (ensidig täthet) | σ² / (fs/2) = 1,25·10⁻⁶ (−59 dB) |
| SNR | 10·log10(0,32 / 0,01) ≈ 15,05 dB |

## Koppling till projektet

FFT, fönster och PSD är grunden för de kommande veckorna. Filterdesign (vecka 4) utvärderas med frekvensgång och PSD. STFT och mel-spektrogram (vecka 5) är FFT:er på fönstrade, överlappande segment, alltså samma idé som Welch men utan medelvärdesbildning. Spectral subtraction (vecka 8) skattar brusets PSD och drar bort den.
