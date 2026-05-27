# get_data_pop_empl.R
#
# Erstellt zwei Abbildungen für den Vortrag-Anhang:
#
#   Folie A4: Bevölkerung, BIP gesamt, BIP pro Kopf, Erwerbspersonen
#             (Deutschland, indexiert 1990 = 100)
#   Folie A5: Jahresarbeitsstunden je Erwerbstätige·n
#             (Deutschland 1970–2024)
#
# Outputs: img/bev-bip-index.png
#          img/arbeitsstunden.png
#
# Datenquellen:
#   WDI (Weltbank):
#     SP.POP.TOTL   — Bevölkerung
#     SL.TLF.TOTL.IN — Erwerbspersonen (Labour Force)
#     NY.GDP.MKTP.KN — BIP in konstanten Landeswährungseinheiten (EUR)
#   IAB / Destatis:
#     data/arbeitsstunden_level.csv

library(WDI)
library(tidyverse)

# ============================================================
# 0.  Design — aus custom.scss übernommen
# ============================================================

col <- list(
  cream  = "#F5F0E8",
  ink    = "#1A1814",
  mid    = "#4A4540",
  accent = "#8B3A2A",   # muted red
  pro    = "#2A5C3F",   # green
  gold   = "#B5860D"    # amber / neutral-warm
)

theme_vortrag <- function(base_size = 13) {
  theme_minimal(base_size = base_size) +
    theme(
      plot.background  = element_rect(fill = col$cream, color = NA),
      panel.background = element_rect(fill = col$cream, color = NA),
      panel.grid.major = element_line(color = "#DDD8CE", linewidth = 0.4),
      panel.grid.minor = element_blank(),
      plot.title       = element_text(color = col$ink,  face = "bold",   size = base_size),
      plot.subtitle    = element_text(color = col$mid,                   size = base_size * 0.85),
      plot.caption     = element_text(color = col$mid,                   size = 9),
      axis.text        = element_text(color = col$mid),
      axis.title       = element_text(color = col$mid),
      legend.position  = "bottom",
      legend.background = element_rect(fill = col$cream, color = NA),
      legend.text      = element_text(color = col$ink,  size  = 10),
      legend.key.width = unit(1.8, "cm")
    )
}

# ============================================================
# 1.  WDI-Daten herunterladen (Deutschland, 1990–2024)
# ============================================================

cat("Lade WDI-Daten für Deutschland...\n")

wdi_raw <- WDI(
  country   = "DE",
  indicator = c(
    bev    = "SP.POP.TOTL",
    erwerb = "SL.TLF.TOTL.IN",
    bip    = "NY.GDP.MKTP.KN"
  ),
  start = 1990,
  end   = 2024
)

# BIP pro Kopf selbst berechnen (BIP / Bevölkerung)
wdi <- wdi_raw |>
  as_tibble() |>
  select(year, bev, erwerb, bip) |>
  filter(!is.na(bev), !is.na(bip)) |>
  mutate(bip_pc = bip / bev) |>
  arrange(year)

cat(sprintf("  Zeitraum in Daten: %d–%d\n", min(wdi$year), max(wdi$year)))

# Basisjahr 1990 muss vorhanden sein
if (!1990 %in% wdi$year) stop("Jahr 1990 nicht in WDI-Daten — Index kann nicht berechnet werden.")

# ============================================================
# 2.  Index berechnen (1990 = 100)
# ============================================================

basis <- wdi |>
  filter(year == 1990) |>
  select(bev, erwerb, bip, bip_pc)

wdi_idx <- wdi |>
  mutate(
    `BIP gesamt`     = bip    / basis$bip    * 100,
    `BIP pro Kopf`   = bip_pc / basis$bip_pc * 100,
    Erwerbspersonen  = erwerb / basis$erwerb * 100,
    Bevölkerung      = bev    / basis$bev    * 100
  ) |>
  select(year, `BIP gesamt`, `BIP pro Kopf`, Erwerbspersonen, Bevölkerung) |>
  pivot_longer(-year, names_to = "variable", values_to = "index") |>
  filter(!is.na(index)) |>
  # Reihenfolge für Legende (oben = prominenteste Linie)
  mutate(variable = factor(variable, levels = c(
    "BIP gesamt", "BIP pro Kopf", "Erwerbspersonen", "Bevölkerung"
  )))

# ============================================================
# 3.  Abbildung A4: Bevölkerung, Erwerbspersonen & BIP
# ============================================================

linien_farben <- c(
  "BIP gesamt"      = col$accent,
  "BIP pro Kopf"    = col$pro,
  "Erwerbspersonen" = col$gold,
  "Bevölkerung"     = col$mid
)

linien_typen <- c(
  "BIP gesamt"      = "solid",
  "BIP pro Kopf"    = "solid",
  "Erwerbspersonen" = "dashed",
  "Bevölkerung"     = "dotted"
)

# Endwerte für Beschriftung rechts
endwerte <- wdi_idx |>
  group_by(variable) |>
  filter(year == max(year)) |>
  ungroup()

p_bev <- ggplot(wdi_idx, aes(x = year, y = index, color = variable, linetype = variable)) +
  # Referenzlinie 100
  geom_hline(yintercept = 100, color = col$mid, linewidth = 0.35, linetype = "dotted") +
  annotate("text", x = 1990.4, y = 102,
           label = "1990 = 100", hjust = 0, color = col$mid, size = 3.1) +
  # Zeitreihen
  geom_line(linewidth = 1.15) +
  # Endwert-Labels
  geom_text(data = endwerte,
            aes(label = sprintf("%.0f", index)),
            hjust = -0.25, size = 3.3, fontface = "bold", show.legend = FALSE) +
  # Skalen
  scale_color_manual(values = linien_farben) +
  scale_linetype_manual(values = linien_typen) +
  scale_x_continuous(
    breaks = seq(1990, 2025, 5),
    limits = c(1990, max(wdi_idx$year) + 3)   # Platz für Labels
  ) +
  labs(
    title   = "Bevölkerung, Erwerbspersonen und BIP — Deutschland",
    x       = NULL,
    y       = "Index (1990 = 100)",
    color   = NULL, linetype = NULL,
    caption = paste0(
      "Quelle: World Development Indicators, Weltbank  ·  ",
      "BIP in konstanten Landeswährungseinheiten (EUR)  ·  ",
      "BIP pro Kopf = BIP / Bevölkerung"
    )
  ) +
  theme_vortrag() +
  guides(
    color    = guide_legend(nrow = 2),
    linetype = guide_legend(nrow = 2)
  )

out_bev <- here::here("img", "bev-bip-index.png")
# Fallback falls `here` nicht installiert
if (!requireNamespace("here", quietly = TRUE)) {
  out_bev <- "img/bev-bip-index.png"
}

ggsave(out_bev, p_bev, width = 9, height = 5.5, dpi = 150, bg = col$cream)
cat(sprintf("✓ %s gespeichert\n", out_bev))

# ============================================================
# 4.  Abbildung A5: Jahresarbeitsstunden je Erwerbstätige·n
# ============================================================

cat("\nLade Arbeitsstunden-Daten...\n")

# Ggf. Pfad anpassen falls Skript aus anderem Verzeichnis gerufen wird
arb_path <- if (file.exists("data/arbeitsstunden_level.csv")) {
  "data/arbeitsstunden_level.csv"
} else if (file.exists("arbeitsstunden_level.csv")) {
  "arbeitsstunden_level.csv"
} else {
  stop("arbeitsstunden_level.csv nicht gefunden.")
}

arb_raw <- read_csv(arb_path, show_col_types = FALSE)

# Konsistente Zeitreihe:
#   - Westdeutschland  bis 1990 (kein Gesamtdeutschland verfügbar)
#   - Gesamtdeutschland ab 1991 (beide 1991 verfügbar — Gesamtdeutschland bevorzugt)
arb_ts <- arb_raw |>
  filter(
    (region == "Westdeutschland"   & jahr <  1991) |
    (region == "Gesamtdeutschland" & jahr >= 1991)
  ) |>
  arrange(jahr)

cat(sprintf("  Zeitraum: %d–%d  |  %d Beobachtungen\n",
            min(arb_ts$jahr), max(arb_ts$jahr), nrow(arb_ts)))

# Endwert für Annotation
letzter      <- arb_ts |> slice_max(jahr, n = 1)
label_endwert <- sprintf("%d Std.\n(%d)", letzter$arbeitsstunden_je_erwerbstaetigen, letzter$jahr)

p_arb <- ggplot(arb_ts, aes(x = jahr, y = arbeitsstunden_je_erwerbstaetigen)) +
  # Wiedervereinigung markieren
  geom_vline(xintercept = 1991, linetype = "dashed",
             color = col$mid, linewidth = 0.45) +
  annotate("text", x = 1991.6, y = 1920,
           label = "Wiedervereinigung\n(ab hier: Gesamtdeutschland)",
           hjust = 0, color = col$mid, size = 3.0, lineheight = 1.1) +
  # Hauptlinie
  geom_line(color = col$accent, linewidth = 1.2) +
  geom_point(color = col$accent, size = 2.2,
             shape = 21, fill = col$cream, stroke = 1.2) +
  # Endwert-Label
  annotate("text",
           x = letzter$jahr + 0.8,
           y = letzter$arbeitsstunden_je_erwerbstaetigen,
           label = label_endwert,
           hjust = 0, color = col$accent, size = 3.4,
           fontface = "bold", lineheight = 1.1) +
  # Skalen
  scale_x_continuous(
    breaks = seq(1970, 2025, 5),
    limits = c(1969, max(arb_ts$jahr) + 5)
  ) +
  scale_y_continuous(
    breaks = seq(1200, 2100, 100),
    limits = c(1250, 2050)
  ) +
  labs(
    title   = "Jahresarbeitsstunden je Erwerbstätige·n — Deutschland 1970–2024",
    x       = NULL,
    y       = "Stunden pro Jahr",
    caption = "Quelle: IAB / Destatis  ·  Westdeutschland bis 1990, Gesamtdeutschland ab 1991"
  ) +
  theme_vortrag()

out_arb <- if (!requireNamespace("here", quietly = TRUE)) {
  "img/arbeitsstunden.png"
} else {
  here::here("img", "arbeitsstunden.png")
}

ggsave(out_arb, p_arb, width = 9, height = 5, dpi = 150, bg = col$cream)
cat(sprintf("✓ %s gespeichert\n", out_arb))

cat("\n✓ Fertig. Beide Grafiken in img/ gespeichert.\n")
cat("  Nächster Schritt: Platzhalter in wachstum.qmd (Slides A4 + A5) durch Grafiken ersetzen.\n")
