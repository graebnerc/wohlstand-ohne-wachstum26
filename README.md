# Wohlstand ohne Wachstum – Illusion oder Notwendigkeit?

Präsentationsmaterial zum Vortrag von **Prof. Dr. Claudius Gräbner-Radkowitsch**  
im Rahmen des Formats **„Listen to the Science"**  
**Landesverband Schleswig-Holstein · Bündnis 90/Die Grünen**  
26. Mai 2026

---

## Folien ansehen

Die fertig gerenderten Slides sind als selbstständige HTML-Datei verfügbar:

👉 **[Slides öffnen](https://graebnerc.github.io/wohlstand-ohne-wachstum26/wachstum.html)**

**Navigation:**
- `→` / `Leertaste` — nächste Folie
- `←` — vorherige Folie
- `F` — Vollbild
- `Esc` — Übersicht aller Folien

**Export als PDF:**
- Unten links auf das Hamburger-Menü (☰) klicken → „Tools" → „PDF EXPORT MODE"
- Die aufgerufene Seite ausdrucken (Drucker: „Als PDF speichern" o.ä.)

---

## Inhalt

Der Vortrag gibt einen wissenschaftlich ausgewogenen Überblick über die Wachstumsdebatte — ohne eine Position zu bevorzugen, bis zum abschließenden Fazit.

| Nr | Abschnitt | Inhalt |
|----|-----------|--------|
| 01 | Grundlagen | Was ist Wachstum? BIP als Konzept und seine Grenzen |
| 02 | Pro-Wachstum | Argumente für Wachstum mit Evidenzeinschätzung |
| 03 | Contra-Wachstum | Ökologische Grenzen, Wohlbefinden, Ungleichheit |
| 04 | Diskussion | Suffizienz, drei wissenschaftliche Schulen, Wachstumszwang |
| 05 | Fazit | Persönliche Einschätzung & offene Fragen |

**Anhang** (vertiefendes Material):

| Abschnitt | Inhalt |
|-----------|--------|
| A · Das BIP | Definition, drei Berechnungsarten, Bevölkerung & Arbeitszeit |
| B · Ökologische Grenzen | CO₂-Budget und Technologiedynamik |
| C · Suffizienz | Was ist das? Wie konsistent integrieren? (CLEVER-Szenario) |
| D · Wachstumszwänge | Verteilungsmechanik, Fiskallogik, Alternativen |

---

## Reproduzieren

### Voraussetzungen

- [Quarto](https://quarto.org) ≥ 1.4
- R mit den Paketen:
  - Grafiken (Hauptvortrag): `ggplot2`, `dplyr`, `scales`, `ggrepel`, `showtext`, `sysfonts`, `readxl`, `tidyr`
  - Grafiken (Anhang A): `WDI`, `tidyverse`

### Grafiken erstellen

```bash
# Hauptvortrag (BIP-HDI, Happiness, Decoupling, WHR)
Rscript make_plots.R

# Anhang A: Bevölkerung/BIP-Index + Arbeitsstunden (lädt WDI-Daten herunter)
Rscript data/get_data_pop_empl.R
```

### Präsentation rendern

```bash
quarto render wachstum.qmd
```

Erzeugt `wachstum.html` — eine vollständig selbstständige Datei (alle Ressourcen eingebettet, keine Internetverbindung zum Ansehen nötig).

---

## Dateistruktur

```
├── wachstum.qmd               ← Präsentationsquelle (Quarto RevealJS)
├── custom.scss                ← Visuelles Design (Farben, Typografie, Komponenten)
├── make_plots.R               ← Grafiken für den Hauptvortrag
├── data/
│   ├── get_data_pop_empl.R    ← Grafiken für Anhang A (WDI-Download + Arbeitsstunden)
│   ├── arbeitsstunden_level.csv        (IAB/Destatis)
│   ├── arbeitsstunden_veraenderung.csv (IAB/Destatis)
│   ├── gdp-vs-hdi.csv                  (Our World in Data)
│   ├── gdp-vs-happiness.csv            (Our World in Data)
│   ├── co2-emissions-and-gdp-per-capita.csv (Our World in Data)
│   └── WHR26_Data_Figure_2.1 (2).xlsx  (World Happiness Report 2026)
└── img/                       ← Alle Abbildungen (generiert + extern)
```

---

## Lizenz und Nachnutzung

Der Vortrag und alle selbst erstellten Grafiken stehen unter  
**Creative Commons Attribution 4.0 (CC BY 4.0)** — Nachnutzung mit Quellenangabe erwünscht.

Externe Abbildungen verbleiben unter ihren jeweiligen Lizenzen  
(Our World in Data: CC BY; World Happiness Report: Gallup/WHR; Breakthrough Effect: The Breakthrough Effect 2023; World Inequality Report: Chancel et al. 2022).

**Quellenangabe:**  
Gräbner-Radkowitsch, C. (2026). *Wohlstand ohne Wachstum – Illusion oder Notwendigkeit?*  
Vortrag, Listen to the Science, Bündnis 90/Die Grünen SH, 26.05.2026.
