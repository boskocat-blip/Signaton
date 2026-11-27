# Signaton – Data Science LIA Project

**Student:** Biljana Markovic  
**Education:** DS25 – Data Scientist, EC Utbildning  
**Company:** Signaton  
**Supervisor:** Sead Smailagic  
**Period:** November 2, 2026 – April 16, 2027  
**Duration:** 24 weeks (120 Yhp)

## Project Overview

This repository contains the code, experiments, documentation, and results developed during my Data Science internship (LIA) at Signaton.

The project focuses on **Digital Signal Processing (DSP), Voice Enhancement, and Wake Word Detection**, with an emphasis on comparing traditional signal processing techniques with modern Machine Learning and Deep Learning approaches.

Python and R are used for signal processing, statistical analysis, visualization, and model evaluation.

## Project Objectives

The main objectives are to:

- Understand digital audio representation and signal processing fundamentals.
- Develop a reproducible audio data processing pipeline.
- Implement and evaluate traditional voice enhancement techniques.
- Explore ML/AI-based voice enhancement models.
- Develop and evaluate wake word detection methods.
- Compare approaches using objective and subjective evaluation metrics.
- Provide data-driven recommendations to Signaton.

## Project Phases

| Phase | Weeks | Focus |
|---|---|---|
| Phase 1 | 1–6 | DSP Fundamentals & Data Pipeline |
| Phase 2 | 7–12 | Voice Enhancement: Traditional vs. ML/AI |
| Phase 3 | 13–18 | Wake Word Detection, Evaluation & Comparison |
| Phase 4 | 19–24 | Documentation, Reporting & Final Presentation |

## Technologies and Tools

**Programming Languages**
- Python
- R

**Libraries**
- NumPy
- SciPy
- Pandas
- Matplotlib
- SoundFile
- tuneR
- ggplot2
- signal (R)
- Librosa (planned from Week 5)

**Development Tools**
- Visual Studio Code
- Jupyter Notebook
- Git and GitHub

Additional tools and frameworks will be introduced as the project progresses.

## Repository Structure

```text
Signaton/
├── data/              # Generated audio files (not committed)
├── docs/              # Theory and project documentation
├── notebooks/         # Python experiments
├── R/                 # R scripts
├── scripts/           # Supporting scripts
├── figures/           # Generated figures (not committed)
├── reports/           # Weekly progress reports
├── requirements.txt   # Python dependencies
├── .gitignore         # Git exclusions
└── README.md          # Project overview
```

## Weekly Progress

### Week 1 – Environment Setup and Git Workflow

- Configured the Python virtual environment.
- Installed and tested Python libraries.
- Set up R in Visual Studio Code.
- Created and executed a Jupyter Notebook.
- Tested signal visualization in R.
- Configured Git and the GitHub remote.

Files: `notebooks/vecka_01_setup.ipynb`, `R/vecka_01_setup.R`, `docs/vecka_01_setup.md`, `reports/vecka_01_rapport.md`

### Week 2 – Sampling, Quantization, Aliasing and Data Capture

- Sampled a 440 Hz sine wave at 16 000, 2 000 and 600 Hz.
- Demonstrated aliasing (440 Hz → 160 Hz at fs = 600 Hz, 1 200 Hz → 800 Hz at fs = 2 000 Hz) and verified it with FFT.
- Implemented 2-, 4-, 8- and 16-bit quantization and calculated MSE and SQNR (≈ 6 dB per bit).
- Generated a 16-bit PCM WAV file in Python and verified its format in both Python and R.
- Notebook, R script and theory notes use the same parameters and examples.

Files: `notebooks/vecka_02_sampling_kvantisering_aliasing.ipynb`, `R/vecka_02_sampling.R`, `docs/vecka_02_teori.md`, `reports/vecka_02_rapport.md`

### Week 3 – FFT, Window Functions and PSD

- Computed amplitude spectra with FFT and showed how frequency resolution depends on the analysis length (Δf = fs/N).
- Demonstrated spectral leakage (437.5 Hz on-bin vs. 440 Hz between bins at N = 1 024).
- Compared rectangular, Hann, Hamming and Blackman windows (sidelobes −13/−31/−43/−58 dB, ENBW, main lobe width) and showed that a −40 dB tone is hidden by leakage without a window.
- Estimated PSD with periodogram and Welch; verified Parseval, the noise floor (1.25·10⁻⁶) and SNR (≈ 15 dB).
- Same experiments in R (base `fft`, own Welch implementation, `ggplot2`).

Files: `notebooks/vecka_03_fft_fonster_psd.ipynb`, `R/vecka_03_fft_psd.R`, `docs/vecka_03_teori.md`, `reports/vecka_03_rapport.md`

### Week 4 – Digital Filter Design (FIR/IIR)

- Derived the frequency response of a moving-average filter and verified it against the formula.
- Designed a 101-tap FIR lowpass (window method, Hamming) with linear phase and a constant 50-sample delay.
- Designed a 4th-order Butterworth IIR lowpass, checked stability (poles inside the unit circle) and compared orders 2, 4 and 8.
- Compared FIR and IIR (attenuation, delay, phase, cost) and applied a zero-phase 300–3400 Hz bandpass to a noisy test signal (SNR 2.7 → 21 dB).
- Same experiments in R with the `signal` package.

Files: `notebooks/vecka_04_filterdesign.ipynb`, `R/vecka_04_filter.R`, `docs/vecka_04_teori.md`, `reports/vecka_04_rapport.md`

### Upcoming Work

**Week 5:** STFT, mel-spectrograms and cepstral analysis.

**Week 6:** Audio feature extraction (MFCC, RMS, ZCR) and data pipeline integration.

## Running the Project

### Python

Create a virtual environment:

```bash
python -m venv .venv
```

Activate it on Windows PowerShell:

```powershell
.\.venv\Scripts\Activate.ps1
```

Install dependencies:

```bash
python -m pip install -r requirements.txt
```

Open the Jupyter notebooks in Visual Studio Code and select the `.venv` Python kernel.

### R

Install the packages used by the R scripts:

```r
install.packages(c("tuneR", "ggplot2", "signal"))
```

Run the notebook for a week first (it creates `data/test_signal_440hz.wav`), then run the R script from the project root:

```r
source("R/vecka_02_sampling.R")
source("R/vecka_03_fft_psd.R")
source("R/vecka_04_filter.R")
```

## Documentation

The repository includes weekly reports, theoretical notes, experiments and reflections.

Weekly reports are stored in the `reports/` directory.

The report template is available in `docs/fredagsrapport_mall.md` and the Git workflow in `docs/git_workflow.md`.

## Project Status

**Current stage:** Phase 1 – DSP Fundamentals & Data Pipeline

**Completed:** Weeks 1–4

**Next milestone:** Week 5 – STFT, Mel-Spectrograms and Cepstral Analysis

---

*This repository documents my learning process, technical development and practical application of Data Science methods during my LIA internship at Signaton.*