# GitHub — ladda upp endast vecka 1–2

Om repot redan är klonat, gå in i dess mapp. Kopiera filerna från detta paket till repots rot. Kopiera **inte** en extra överordnad projektmapp.

```bash
git status
git remote -v
git switch -c vecka-01-02
git add README.md requirements.txt .gitignore notebooks scripts docs
git commit -m "Add LIA weeks 1 and 2"
git push -u origin vecka-01-02
```

Öppna sedan en pull request till `main`. Om branchen redan finns, använd `git switch vecka-01-02`. Om `origin` saknas: `git remote add origin https://github.com/boskocat-blip/Signaton.git`. Kör inte `git init` i ett redan klonat repo.

Undvik att committa `.venv`, personuppgifter eller konfidentiella inspelningar.
