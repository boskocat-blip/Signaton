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

### Upcoming Work

**Week 3:** Fast Fourier Transform (FFT), window functions and Power Spectral Density (PSD).

**Week 4:** Digital filter design (FIR/IIR).

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

Install the required R package:

```r
install.packages("tuneR")
```

Run the Week 2 notebook first (it creates `data/test_signal_440hz.wav`), then run the Week 2 script from the project root:

```r
source("R/vecka_02_sampling.R")
```

## Documentation

The repository includes weekly reports, theoretical notes, experiments and reflections.

Weekly reports are stored in the `reports/` directory.

The report template is available in `docs/fredagsrapport_mall.md` and the Git workflow in `docs/git_workflow.md`.

## Project Status

**Current stage:** Phase 1 – DSP Fundamentals & Data Pipeline

**Completed:** Weeks 1–2

**Next milestone:** Week 3 – FFT, Window Functions and PSD

---

*This repository documents my learning process, technical development and practical application of Data Science methods during my LIA internship at Signaton.*