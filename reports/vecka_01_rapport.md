# Fredagsrapport – LIA Signaton

**Student:** Biljana Markovic  
**Utbildning:** DS25 – Data Scientist  
**LIA-företag:** Signaton  
**Handledare:** Sead Smailagic  
**Vecka:** 1 (v. 45)  
**Period:** 2–6 november 2026  
**Status:** Klar

---

## Sammanfattning på tre rader

1. Satte upp en reproducerbar arbetsmiljö för Python och R, projektstruktur och GitHub-repo.
2. Python- och R-miljön fungerar lokalt och vecka 1-notebooken körs utan fel.
3. Inget blockerar.

---

## 1. Veckans mål

- Mål 1: Skapa en reproducerbar arbetsmiljö för Python och R.
- Mål 2: Lära mig Git-flödet och koppla projektet till GitHub.
- Mål 3: Planera veckorutinen och dokumentationen (README, fredagsrapport).

## 2. Genomförda aktiviteter

- Installerade Python och R och konfigurerade Visual Studio Code för båda språken.
- Skapade en virtuell Python-miljö (`.venv`) och installerade paketen i `requirements.txt`.
- Körde `notebooks/vecka_01_setup.ipynb`, som kontrollerar Python-version, paket och projektmappar.
- Körde `R/vecka_01_setup.R`, som kontrollerar R-versionen och ritar en enkel testsignal.
- Skapade projektstrukturen (`notebooks/`, `R/`, `docs/`, `reports/`, `scripts/`, `data/`).
- Kopplade det lokala repot till GitHub-remoten och skrev en första version av `README.md`.

## 3. Tekniker och verktyg

**Programmeringsspråk:**  
Python / R

**Bibliotek och verktyg:**  
NumPy, SciPy, Matplotlib, Pandas, SoundFile, Jupyter Notebook, Visual Studio Code, base R

**Versionshantering:**  
Git och GitHub

## 4. Resultat och observationer

- Alla paket i `requirements.txt` hittas i `.venv`-kärnan och notebooken körs utan fel.
- R fungerar både från terminalen (`Rscript --version`) och i VS Code, och testgrafen visas.
- Projektstrukturen är på plats och följer README.

Veckan gav inga experimentella resultat. Det viktigaste resultatet är en fungerande och dokumenterad miljö som de kommande veckornas experiment kan byggas på.

## 5. Utmaningar och problemlösning

[Jag hade mest problem men enviorment, kernels, och hur ska jag organisera project]

## 6. Reflektion och lärdomar

Jag har lärt mig hur en virtuell miljö och en `requirements.txt` gör projektet reproducerbart, och hur Python och R kan användas i samma projekt. Jag har också lärt mig grunderna i Git-flödet med branch, commit, push och pull request.

En fungerande miljö och en tydlig mappstruktur från början gör det lättare att hålla notebooks, skript och rapporter konsekventa under resten av LIA-perioden.

## 7. Planering inför nästa vecka

Vecka 2: sampling, Nyquist och aliasing, kvantisering (MSE och SQNR) samt data capture med WAV-filer i både Python och R.

Inga frågor till handledaren just nu.

## 8. Länkar och dokumentation

**GitHub:** [Repo](https://github.com/boskocat-blip/Signaton) · PR: [#1 Vecka 1–2](https://github.com/boskocat-blip/Signaton/pull/1)

**Notebooks:** [`notebooks/vecka_01_setup.ipynb`](../notebooks/vecka_01_setup.ipynb) · [`R/vecka_01_setup.R`](../R/vecka_01_setup.R)

**Rapporter:** [`docs/vecka_01_setup.md`](../docs/vecka_01_setup.md) · [`docs/git_workflow.md`](../docs/git_workflow.md)
