# Git-flöde — vecko-baserad branch + pull request

**Princip:** `main` är alltid i körbart och dokumenterat skick. Varje vecka arbetar du på en egen branch och avslutar med en pull request (PR) till `main`. Små medvetna commits under veckan — inte en stor dump-commit på fredagen.

## 1. Start av veckan (måndag)

```bash
git switch main
git pull origin main
git switch -c vecka-03-fft
```

### Branchnamn: `vecka-NN-kort-beskrivning`

| Vecka | Branch |
|---|---|
| 3 | `vecka-03-fft` |
| 4 | `vecka-04-filter` |
| 5 | `vecka-05-stft` |
| 6 | `vecka-06-pipeline` |


## 2. Under veckan — kommittrutin

```bash
git status                 # alltid före arbete
git add <specifika filer>  # undvik `git add .`
git commit -m "<typ>: <kort beskrivning>"
```

### Commit-mallar — typen är en av: `notebook` | `docs` | `fix` | `data` | `chore`

```
notebook: vecka 3 FFT-demo med olika fönsterfunktioner
notebook: lägga till PSD-beräkning och figur
docs: vecka 3 teori — fönsterfunktioner och lekage
fix: korrektera PSD-skalning i vecka_03-notebook
data: lägga till demo_440hz_8k.wav
chore: uppdatera .gitignore med genererade figurer
wip: vecka 3 — fastnade vid PSD-normalisering, se rapport
```

## 3. Avslut av veckan (fredag)

1. Kör om veckans notebook (**Run All**) och spara med outputs.
2. Uppdatera `README.md` (veckostatus) och skriv `reports/vecka_0N_rapport.md` enligt `docs/fredagsrapport_mall.md` (alla sektioner 1–8).
3. Pusha branchen och öppna PR i GitHub (*Compare & pull request*):

   ```bash
   git push -u origin vecka-03-fft
   ```

4. Granska PR:en själv (*Files changed*), klistra in PR-länken i rapportens sektion 8 (Länkar).
5. Merge:a PR:en (**squash and merge**) och radera branchen:

   ```bash
   git switch main
   git pull origin main
   git branch -d vecka-03-fft
   ```

## 4. Regler

- **Commita aldrig:** `.venv`, personuppgifter, inspelade röster utan godkännande, konfidentiell data.
- **Genererade filer** (WAV, figurer som skapas vid körning) ska inte committas — lägg till dem i `.gitignore`. Behövs en liten demo-fil, dokumentera varför i commit-meddelandet.
- **Commita inte halva celler eller kommenterad ut kod** — ta bort, eller kommentera varför den behålls.
- **Fastnat?** Gör en `wip:`-commit och maila handledaren med commit-länk och exakt var det stoppades.
- **`main` innehåller aldrig trasig kod** — kör alltid notebooken lokalt innan push.

## 5. En vecka i tidslinje (exempel)

```
måndag    git switch -c vecka-03-fft
tisdag    git commit -m "notebook: FFT av 440 Hz sinus, fönsterfunktioner"
onsdag    git commit -m "notebook: PSD med rektangulär, hamming och hanning"
torsdag   git commit -m "docs: vecka 3 teori — frekvensupplösning och lekage"
fredag    git push -u origin vecka-03-fft  →  PR  →  squash merge  →  vecka klar
```
