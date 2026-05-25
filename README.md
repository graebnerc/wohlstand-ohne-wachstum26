# Wohlstand ohne Wachstum – Illusion oder Notwendigkeit?

Präsentationsmaterial zum Vortrag von **Prof. Dr. Claudius Gräbner-Radkowitsch**  
im Rahmen des Formats **„Listen to the Science"**  
**Landesverband Schleswig-Holstein · Bündnis 90/Die Grünen**  
26. Mai 2026

---

## Folien ansehen

Die fertig gerenderten Slides sind als selbstständige HTML-Datei verfügbar:

👉 **[Slides öffnen]([https://claudius-graebner.github.io/26-05-GrueneWachstum/wachstum.html](https://graebnerc.github.io/wohlstand-ohne-wachstum26/wachstum.html#/title-slide))**

**Navigation:**
- `→` / `Leertaste` — nächste Folie
- `←` — vorherige Folie
- `F` — Vollbild
- `Esc` — Übersicht aller Folien

**Export als PDF:**
- Unten links auf das Hamburger-Menü (Menüsymbol mit drei waagerechten Linien: ☰) klicken
- Klicke oben links auf "Tools"
- Dann auf "PDF EXPORT MODE"
- Die dadurch aufgerufene Seite kannst du drucken und dann dann als Drucker "PDF Export" (o.ä.) auswählen

---

## Inhalt

Der Vortrag gibt einen wissenschaftlich ausgewogenen Überblick über die Wachstumsdebatte — möglichst ohne eine Position zu bevorzugen, bis zum abschließenden Fazit.

| Abschnitt | Inhalt |
|-----------|--------|
| Grundlagen | Was ist Wachstum? BIP als Konzept und seine Grenzen |
| Pro-Wachstum | Fünf Argumente mit Evidenzeinschätzung und Einschränkungen |
| Contra-Wachstum | Ökologische Grenzen, Wohlbefinden, Ungleichheit |
| Implikationen | Suffizienz, drei wissenschaftliche Schulen, Politische Positionen |
| Ausblick | Offene Fragen, Fazit |
| Anhang | BIP-Details, Entkopplungsdaten, Wachstumszwang (r-g-Modell) |

---

## Reproduzieren

### Voraussetzungen

- [Quarto](https://quarto.org) ≥ 1.4
- R mit den Paketen: `ggplot2`, `dplyr`, `scales`, `ggrepel`, `showtext`, `sysfonts`, `readxl`, `tidyr`, `ggtext`
- Internetverbindung (Google Fonts beim ersten Render)

### Grafiken erstellen

```bash
Rscript make_plots.R
```

Erzeugt alle Abbildungen in `img/` aus den Datensätzen in `data/`.

### Präsentation rendern

```bash
quarto render wachstum.qmd
```

Erzeugt `wachstum.html` — eine vollständig selbstständige Datei (alle Ressourcen eingebettet).

---

## Struktur

```
├── wachstum.qmd          ← Präsentationsquelle (Quarto RevealJS)
├── custom.scss           ← Visuelles Design (Farben, Typografie, Komponenten)
├── make_plots.R          ← R-Skript für alle Abbildungen
├── data/                 ← Rohdaten (OWID, WHR)
│   ├── gdp-vs-hdi.csv
│   ├── gdp-vs-happiness.csv
│   ├── gdp-vs-researchers.csv
│   ├── co2-emissions-and-gdp-per-capita.csv
│   └── WHR26_Data_Figure_2.1 (2).xlsx
└── img/                  ← Abbildungen (generiert + extern)
```

---

## Lizenz und Nachnutzung

Der Vortrag und alle selbst erstellten Grafiken stehen unter  
**Creative Commons Attribution 4.0 (CC BY 4.0)** — Nachnutzung mit Quellenangabe erwünscht.

Externe Abbildungen verbleiben unter ihren jeweiligen Lizenzen (Our World in Data: CC BY; World Happiness Report: Gallup/WHR).

**Quellenangabe:** Gräbner-Radkowitsch, C. (2026). *Wohlstand ohne Wachstum – Illusion oder Notwendigkeit?* Vortrag, Listen to the Science, Bündnis 90/Die Grünen SH, 26.05.2026.
