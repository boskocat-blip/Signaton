# Veckorapport – Vecka 2

**LIA:** Signaton – Data Scientist (DS25)  
**Period:** 9–13 november 2026  
**Fas:** 1 – DSP-grunder & Data Pipeline  
**Fokus:** Sampling, kvantisering, aliasing och data capture

## 1. Syfte

Syftet med veckan var att förstå hur analoga ljudsignaler representeras digitalt och hur samplingsfrekvens och bitdjup påverkar signalens kvalitet.

Arbetet genomfördes i både Python och R för att tillämpa kunskaper inom programmering, matematik och statistisk dataanalys.

## 2. Genomförande

### Sampling

Jag genererade en syntetisk sinussignal med frekvensen 440 Hz och visualiserade signalen med hjälp av NumPy och Matplotlib i Python samt grundläggande plotfunktioner i R.

Jag undersökte hur olika samplingsfrekvenser påverkar antalet sampel och signalens representation.

### Aliasing

Jag jämförde samplingsfrekvenserna 16 000 Hz, 2 000 Hz och 600 Hz för samma signal.

Vid 600 Hz uppfylldes inte Nyquistvillkoret för signalen på 440 Hz. Detta demonstrerade aliasing, där signalen kan representeras som en lägre frekvens på 160 Hz.

### Kvantisering

Jag implementerade en kvantiseringsfunktion och jämförde tre olika bitdjup:

- 4 bitar – 16 kvantiseringsnivåer
- 8 bitar – 256 kvantiseringsnivåer
- 16 bitar – 65 536 kvantiseringsnivåer

Jag beräknade Mean Squared Error (MSE) för att undersöka skillnaden mellan originalsignalen och den kvantiserade signalen.

### Data capture och WAV-filer

Jag genererade en två sekunder lång ljudsignal med samplingsfrekvensen 16 000 Hz och sparade den som en WAV-fil med 16-bitars PCM-format.

Därefter läste jag in ljudfilen i Python med bibliotek