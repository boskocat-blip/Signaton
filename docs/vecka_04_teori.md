# Vecka 4 — Teori och förväntade resultat: filterdesign (FIR och IIR)

Teorin hör ihop med `notebooks/vecka_04_filterdesign.ipynb` och `R/vecka_04_filter.R`. Samplingsfrekvensen är 16 000 Hz som tidigare veckor.

## Differensekvation

Ett linjärt, tidsinvariant digitalt filter beräknar utsignalen från insignalen och (för IIR) tidigare utsampel:

```
y[n] = b0·x[n] + b1·x[n−1] + … + bM·x[n−M] − a1·y[n−1] − … − aN·y[n−N]
```

- **FIR** (Finite Impulse Response): alla a_k = 0. Impulssvaret är b-koefficienterna och tar slut efter M + 1 sampel.
- **IIR** (Infinite Impulse Response): minst ett a_k ≠ 0. Återkopplingen gör att impulssvaret i princip aldrig tar slut.

## z-transformen och överföringsfunktionen

z-transformen gör en fördröjning med ett sampel till en multiplikation med z⁻¹. Differensekvationen blir då

```
H(z) = Y(z) / X(z) = (b0 + b1·z⁻¹ + … + bM·z⁻ᴹ) / (1 + a1·z⁻¹ + … + aN·z⁻ᴺ)
```

- **Nollställen** = rötter till täljaren. Där blir H = 0.
- **Poler** = rötter till nämnaren. Nära en pol blir |H| stort.
- **Stabilitet:** ett IIR-filter är stabilt om och endast om alla poler ligger innanför enhetscirkeln, |p| < 1.

**Frekvenssvaret** fås genom att sätta z = e^(jω), där ω = 2π·f/fs:

```
H(f) = Σ b_k·e^(−jωk) / Σ a_k·e^(−jωk)
```

|H(f)| är amplitudsvaret (förstärkning) och arg H(f) är fasen. **Gruppfördröjningen** τ(f) = −dφ/dω (i sampel) säger hur mycket varje frekvens fördröjs.

## Exempel: glidande medelvärde

M = 5 sampel, b_k = 1/5. Geometrisk summa ger

```
|H(f)| = | sin(π·f·M/fs) / (M·sin(π·f/fs)) |
```

Nollställen vid f = k·fs/M = 3 200 och 6 400 Hz. Vid 1 000 Hz är |H| = 0,852.

## FIR-design med fönstermetoden

Det ideala lågpassfiltret har impulssvaret h_ideal[n] = 2·(fc/fs)·sinc(2·(fc/fs)·n), som är oändligt långt. Fönstermetoden:

1. Förskjut sinc så att den centreras i (N − 1)/2.
2. Klipp till N koefficienter.
3. Multiplicera med ett fönster, här Hamming (samma avvägning som i vecka 3: lägre sidlober, bredare övergång).

**Egenskaper:**
- Symmetriska koefficienter ger **linjär fas**: alla frekvenser fördröjs (N − 1)/2 sampel. För N = 101 är det 50 sampel = 3,125 ms.
- Gränsfrekvensen fc är filtrets −6 dB-punkt (amplituden halveras).
- Dämpningen i spärrbandet bestäms av fönstret (Hamming cirka −53 dB eller bättre), och övergångens bredd av N (cirka 3,3·fs/N för Hamming).

**Förväntat (N = 101, fc = 1 000 Hz):** −6 dB vid 1 000 Hz, −3 dB vid cirka 937 Hz, cirka −60 dB vid 2 000 Hz, cirka −76 dB vid 6 000 Hz.

## IIR-design: Butterworth

Butterworth är maximalt platt i passbandet. Det analoga prototypfiltret av ordning n:

```
|H(f)|² = 1 / (1 + (f/fc)^(2n))
```

- Exakt −3 dB vid fc, för alla ordningar.
- Branthet cirka 6·n dB per oktav (20·n dB per dekad) långt från fc.
- Den digitala versionen fås med **bilinjär transform**, som avbildar hela den analoga frekvensaxeln på 0 … fs/2. Det gör att dämpningen nära Nyquist blir större än för prototypen.

| Ordning | 1 000 Hz | 2 000 Hz | 4 000 Hz |
|---|---|---|---|
| 2 | −3,0 dB | −13,0 dB | −28,1 dB |
| 4 | −3,0 dB | −25,5 dB | −56,1 dB |
| 8 | −3,0 dB | −51,0 dB | −112,2 dB |

Dubbel ordning ger dubbel dämpning i dB. Ordning 4 har poler med |p| = 0,863 och 0,691, och alla nollställen i z = −1 (Nyquist).

## FIR och IIR i jämförelse

| Egenskap | FIR (fönster, N = 101) | IIR (Butterworth, ordning 4) |
|---|---|---|
| Koefficienter | 101 | 10 (5 b + 5 a) |
| Fas | linjär | olinjär |
| Fördröjning | konstant 50 sampel | 6,6–10 sampel, störst nära fc |
| Stabilitet | alltid | om alla \|p\| < 1 |
| Dämpning 2 000 Hz | cirka −60 dB | cirka −25 dB |

FIR väljs när fasen är viktig (till exempel när signalens form ska bevaras) och beräkningskraften räcker. IIR väljs när beräkningen ska vara billig och lite fasdistorsion går bra.

## Nollfasfiltrering (filtfilt)

`filtfilt` filtrerar framåt och sedan bakåt. Fasförskjutningarna tar ut varandra (nollfas), och amplitudsvaret blir |H|², det vill säga dubbel dämpning i dB. Det kräver hela signalen i förväg och fungerar därför bara offline, inte i realtid.

## Tillämpning: telefonbandet 300–3 400 Hz

Testsignal: 440 Hz (amplitud 0,5) + brum 50 Hz (0,3) + störton 6 000 Hz (0,2) + vitt brus (σ = 0,05).

| Storhet | Förväntat |
|---|---|
| SNR före | 10·log10(0,125 / (0,045 + 0,02 + 0,0025)) ≈ 2,7 dB |
| Brum och störton efter bandpass | i princip borta (under −80 dB) |
| Brus efter bandpass | cirka 10·log10(3 100 / 8 000) ≈ −4 dB |
| SNR efter | cirka 21 dB |

## Koppling till projektet

Bandpass- och högpassfilter används som förbehandling av tal (ta bort brum och höga frekvenser). Förståelsen av fas och fördröjning blir viktig i fas 2 (röstförbättring) och fas 3 (wake word), där fördröjning i realtid spelar roll. STFT i vecka 5 kan ses som en bank av bandpassfilter.
