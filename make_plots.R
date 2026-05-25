library(ggplot2)
library(dplyr)
library(scales)
library(ggrepel)
library(showtext)
library(sysfonts)

font_add_google("Playfair Display", "playfair")
font_add_google("Source Serif 4", "sourceserif")
showtext_auto()
showtext_opts(dpi = 150)

# Farben (direkt aus custom.scss)
cream      <- "#F5F0E8"
ink        <- "#1A1814"
mid        <- "#4A4540"
akzent     <- "#8B3A2A"

farben_region <- c(
  "Europa"       = "#2A5C3F",
  "Asien"        = "#C4743B",
  "Afrika"       = "#8B3A2A",
  "Nordamerika"  = "#4A6B8A",
  "Südamerika"   = "#7A5C8A",
  "Ozeanien"     = "#6B8A5C"
)

region_map <- c(
  "Asia"          = "Asien",
  "Europe"        = "Europa",
  "Africa"        = "Afrika",
  "North America" = "Nordamerika",
  "South America" = "Südamerika",
  "Oceania"       = "Ozeanien"
)
region_lvl <- c("Europa", "Asien", "Afrika", "Nordamerika", "Südamerika", "Ozeanien")

theme_wachstum <- function(base_size = 13) {
  theme_minimal(base_size = base_size, base_family = "sourceserif") +
    theme(
      plot.background   = element_rect(fill = cream, color = NA),
      panel.background  = element_rect(fill = cream, color = NA),
      panel.grid.major  = element_line(color = "#DDD5C5", linewidth = 0.4),
      panel.grid.minor  = element_blank(),
      axis.text         = element_text(color = mid),
      axis.title        = element_text(color = ink, size = rel(0.93)),
      plot.title        = element_text(family = "playfair", color = ink,
                                       size = rel(1.15), margin = margin(b = 4)),
      plot.subtitle     = element_text(color = mid, size = rel(0.87),
                                       margin = margin(b = 10)),
      plot.caption      = element_text(color = mid, size = rel(0.72),
                                       hjust = 0, margin = margin(t = 8)),
      legend.background = element_rect(fill = cream, color = NA),
      legend.key        = element_rect(fill = cream, color = NA),
      legend.text       = element_text(color = ink, size = rel(0.83)),
      legend.title      = element_text(color = ink, size = rel(0.88), face = "bold"),
      plot.margin       = margin(12, 16, 8, 12)
    )
}

gdp_breaks <- c(1000, 2000, 5000, 10000, 20000, 50000, 100000)
gdp_labels <- function(x) {
  dplyr::case_when(
    x >= 1000 ~ paste0(x / 1000, "k"),
    TRUE      ~ as.character(x)
  )
}

# ============================================================
# 1. BIP vs. HDI  →  img/gdp-hdi.png
# ============================================================

df_hdi <- read.csv("data/gdp-vs-hdi.csv") |>
  mutate(
    region_de = factor(region_map[World.region.according.to.OWID], levels = region_lvl),
    ist_de    = Code == "DEU"
  )

p_hdi <- ggplot(df_hdi |> filter(!ist_de),
                aes(x = GDP.per.capita, y = Human.Development.Index, color = region_de)) +
  geom_smooth(aes(group = 1), method = "loess", formula = y ~ x,
              color = ink, fill = "#DDD5C5", linewidth = 0.8,
              alpha = 0.35, se = TRUE, show.legend = FALSE) +
  geom_point(alpha = 0.65, size = 2.2) +
  geom_point(data = df_hdi |> filter(ist_de),
             color = akzent, size = 4.5, shape = 18, show.legend = FALSE) +
  geom_text_repel(data = df_hdi |> filter(ist_de),
                  aes(label = "Deutschland"), color = akzent,
                  family = "sourceserif", size = 4, fontface = "bold",
                  box.padding = 0.6, point.padding = 0.4,
                  segment.color = akzent, segment.size = 0.45,
                  show.legend = FALSE) +
  scale_x_log10(breaks = gdp_breaks, labels = gdp_labels) +
  scale_y_continuous(limits = c(0.35, 1.01), breaks = seq(0.4, 1.0, 0.2)) +
  scale_color_manual(values = farben_region, name = "Region") +
  labs(
    title    = "BIP und menschliche Entwicklung korrelieren stark",
    subtitle = "Besonders deutlich bei niedrigen Einkommen — der Effekt flacht ab",
    x        = "BIP pro Kopf (Kaufkraftparität, int. $, log. Skala)",
    y        = "Human Development Index (0–1)",
    caption  = "Quelle: Our World in Data (2023) · UNDP Human Development Report"
  ) +
  theme_wachstum() +
  guides(color = guide_legend(override.aes = list(size = 3, alpha = 1),
                              ncol = 2))

ggsave("img/gdp-hdi.png", p_hdi, width = 6.5, height = 4.6, dpi = 150, bg = cream)
message("Gespeichert: img/gdp-hdi.png")

# ============================================================
# 2. BIP vs. Lebenszufriedenheit  →  img/gdp-happiness.png
# ============================================================

df_h <- read.csv("data/gdp-vs-happiness.csv") |>
  mutate(
    region_de = factor(region_map[World.region.according.to.OWID], levels = region_lvl),
    ist_de    = Code == "DEU"
  )

p_happiness <- ggplot(df_h |> filter(!ist_de),
                      aes(x = GDP.per.capita, y = Life.satisfaction, color = region_de)) +
  geom_smooth(aes(group = 1), method = "lm", formula = y ~ x,
              color = ink, fill = "#DDD5C5", linewidth = 0.8,
              alpha = 0.35, se = TRUE, show.legend = FALSE) +
  geom_point(alpha = 0.65, size = 2.2) +
  geom_point(data = df_h |> filter(ist_de),
             color = akzent, size = 4.5, shape = 18, show.legend = FALSE) +
  geom_text_repel(data = df_h |> filter(ist_de),
                  aes(label = "Deutschland"), color = akzent,
                  family = "sourceserif", size = 4, fontface = "bold",
                  box.padding = 0.6, point.padding = 0.4,
                  segment.color = akzent, segment.size = 0.45,
                  show.legend = FALSE) +
  scale_x_log10(breaks = gdp_breaks, labels = gdp_labels) +
  scale_y_continuous(limits = c(1, 8.2), breaks = 1:8) +
  scale_color_manual(values = farben_region, name = "Region") +
  labs(
    title    = "Lebenszufriedenheit und BIP",
    subtitle = "Log-lineare Trendlinie — Streuung zeigt: BIP erklärt nicht alles",
    x        = "BIP pro Kopf (Kaufkraftparität, int. $, log. Skala)",
    y        = "Lebenszufriedenheit\n(Cantril-Skala, 0–10)",
    caption  = "Quelle: Our World in Data (2024) · Wellbeing Research Centre / Gallup"
  ) +
  theme_wachstum() +
  guides(color = guide_legend(override.aes = list(size = 3, alpha = 1),
                              ncol = 2))

ggsave("img/gdp-happiness.png", p_happiness, width = 6.5, height = 4.6, dpi = 150, bg = cream)
message("Gespeichert: img/gdp-happiness.png")

# ============================================================
# 3. BIP vs. Forschende  →  img/gdp-researchers.png
# ============================================================

df_r <- read.csv("data/gdp-vs-researchers.csv") |>
  mutate(
    region_de = factor(region_map[World.region.according.to.OWID], levels = region_lvl),
    ist_de    = Code == "DEU"
  )

p_research <- ggplot(df_r |> filter(!ist_de),
                     aes(x = GDP.per.capita,
                         y = Researchers.in.R.D..per.million.people.,
                         color = region_de)) +
  geom_smooth(aes(group = 1), method = "lm", formula = y ~ x,
              color = ink, fill = "#DDD5C5", linewidth = 0.8,
              alpha = 0.35, se = TRUE, show.legend = FALSE) +
  geom_point(alpha = 0.65, size = 2.2) +
  geom_point(data = df_r |> filter(ist_de),
             color = akzent, size = 4.5, shape = 18, show.legend = FALSE) +
  geom_text_repel(data = df_r |> filter(ist_de),
                  aes(label = "Deutschland"), color = akzent,
                  family = "sourceserif", size = 4, fontface = "bold",
                  box.padding = 0.6, point.padding = 0.4,
                  segment.color = akzent, segment.size = 0.45,
                  show.legend = FALSE) +
  scale_x_log10(breaks = gdp_breaks, labels = gdp_labels) +
  scale_y_continuous(labels = function(x) format(x, big.mark = ".", decimal.mark = ",",
                                                  scientific = FALSE)) +
  scale_color_manual(values = farben_region, name = "Region") +
  labs(
    title    = "In reicheren Ländern gibt es mehr Forschende",
    subtitle = "Forschende je Million Einwohner nach BIP pro Kopf (2022/23)",
    x        = "BIP pro Kopf (Kaufkraftparität, int. $, log. Skala)",
    y        = "Forschende pro Mio. Einwohner",
    caption  = "Quelle: Our World in Data (2023) · UNESCO / World Bank"
  ) +
  theme_wachstum() +
  guides(color = guide_legend(override.aes = list(size = 3, alpha = 1),
                              ncol = 2))

ggsave("img/gdp-researchers.png", p_research, width = 6.5, height = 4.6, dpi = 150, bg = cream)
message("Gespeichert: img/gdp-researchers.png")

# ============================================================
# 4. World Happiness Report — BIP ≠ Wohlbefinden
#    → img/whr-figure.png
# ============================================================

library(readxl)
library(tidyr)
library(ggtext)

targets <- c("Finland", "Iceland", "Denmark", "Costa Rica", "Sweden",
             "Germany", "Yemen", "Botswana", "Sierra Leone", "Afghanistan")

names_de <- c(
  "Finland"      = "Finnland (#1)",
  "Iceland"      = "Island (#2)",
  "Denmark"      = "Dänemark (#3)",
  "Costa Rica"   = "Costa Rica (#4)",
  "Sweden"       = "Schweden (#5)",
  "Germany"      = "Deutschland (#17)",
  "Yemen"        = "Jemen (#142)",
  "Botswana"     = "Botswana (#143)",
  "Sierra Leone" = "Sierra Leone (#146)",
  "Afghanistan"  = "Afghanistan (#147)"
)

# Stacking order: GDP zuerst (links), Dystopie zuletzt (rechts)
komponenten_en <- c(
  "Explained by: Log GDP per capita",
  "Explained by: Social support",
  "Explained by: Healthy life expectancy",
  "Explained by: Freedom to make life choices",
  "Explained by: Generosity",
  "Explained by: Perceptions of corruption",
  "Dystopia + residual"
)
komponenten_de <- c(
  "Log-BIP pro Kopf",
  "Sozialer Rückhalt",
  "Gesunde Lebenserwartung",
  "Persönliche Freiheit",
  "Hilfsbereitschaft",
  "Korruptionsfreiheit",
  "Dystopie & Residual"
)
names(komponenten_de) <- komponenten_en

farben_whr <- c(
  "Log-BIP pro Kopf"         = "#2A5C3F",
  "Sozialer Rückhalt"        = "#4A6B8A",
  "Gesunde Lebenserwartung"  = "#5C9E6A",
  "Persönliche Freiheit"     = "#C4743B",
  "Hilfsbereitschaft"        = "#D4A853",
  "Korruptionsfreiheit"      = "#9B8A6A",
  "Dystopie & Residual"      = "#C8BDA8"
)

# Länder von unten (tiefstes Ranking) nach oben (höchstes) sortiert
country_order <- c(
  "Afghanistan (#147)", "Sierra Leone (#146)", "Botswana (#143)", "Jemen (#142)",
  "Deutschland (#17)",
  "Schweden (#5)", "Costa Rica (#4)", "Dänemark (#3)", "Island (#2)", "Finnland (#1)"
)

df_whr_raw <- read_excel("data/WHR26_Data_Figure_2.1 (2).xlsx", sheet = 1) |>
  filter(Year == 2025, `Country name` %in% targets) |>
  mutate(land_de = names_de[`Country name`])

df_long <- df_whr_raw |>
  select(land_de, all_of(komponenten_en),
         `Life evaluation (3-year average)`, `Lower whisker`, `Upper whisker`) |>
  pivot_longer(
    cols      = all_of(komponenten_en),
    names_to  = "Komponente_en",
    values_to = "Wert"
  ) |>
  mutate(
    Komponente_de = factor(komponenten_de[Komponente_en], levels = komponenten_de),
    land_de       = factor(land_de, levels = country_order)
  )

df_ci <- df_whr_raw |>
  mutate(land_de = factor(land_de, levels = country_order))

p_whr <- ggplot(df_long, aes(y = land_de, x = Wert, fill = Komponente_de)) +
  # Hintergrundstreifen für Deutschland
  annotate("rect",
           ymin = 4.5, ymax = 5.5, xmin = -Inf, xmax = Inf,
           fill = "#EDE5D8", alpha = 0.8) +
  geom_col(position = position_stack(reverse = TRUE), width = 0.68) +
  # Konfidenzintervalle (ggplot2 >= 4.0 Syntax)
  geom_errorbar(
    data        = df_ci,
    aes(y = land_de,
        xmin = `Lower whisker`, xmax = `Upper whisker`,
        x    = `Life evaluation (3-year average)`),
    inherit.aes = FALSE,
    orientation = "y",
    width       = 0.28, linewidth = 0.65, color = ink
  ) +
  # Kleines Dreieck als Marker neben "Deutschland"
  annotate("text", x = -0.15, y = 5, label = "◀",
           color = akzent, size = 3.5, hjust = 1, family = "sourceserif") +
  scale_fill_manual(
    values = farben_whr,
    guide  = guide_legend(nrow = 3, title = NULL)
  ) +
  scale_x_continuous(limits = c(0, 8.5), breaks = seq(0, 8, 2),
                     expand = expansion(mult = c(0, 0.02))) +
  coord_cartesian(clip = "off") +
  labs(
    title    = "Lebenszufriedenheit: mehr als Wirtschaftsleistung",
    subtitle = "World Happiness Report 2026 · 3-Jahres-Durchschnitt 2022–2025",
    x        = "Lebenszufriedenheit (Cantril-Skala, 0–10)",
    y        = NULL,
    caption  = "Quelle: Gallup World Poll / World Happiness Report (2026)"
  ) +
  theme_wachstum(base_size = 12) +
  theme(
    legend.position = "bottom",
    legend.key.size = unit(0.45, "cm"),
    plot.margin     = margin(12, 20, 8, 30)
  )

ggsave("img/whr-figure.png", p_whr, width = 8, height = 5.8, dpi = 150, bg = cream)
message("Gespeichert: img/whr-figure.png")

# ============================================================
# 6. Absolute Entkopplung: CO₂ und BIP seit 1990
#    → img/decoupling.png
# ============================================================

library(tidyr)

df_dec_raw <- read.csv("data/co2-emissions-and-gdp-per-capita.csv") |>
  filter(!is.na(Entity)) |>
  mutate(land_de = dplyr::case_match(
    Entity,
    "China"         ~ "China",
    "Germany"       ~ "Deutschland",
    "India"         ~ "Indien",
    "Switzerland"   ~ "Schweiz",
    "United States" ~ "USA",
    "World"         ~ "Welt"
  )) |>
  filter(!is.na(land_de))

base_1990 <- df_dec_raw |>
  filter(Year == 1990) |>
  select(land_de,
         base_gdp  = GDP.per.capita,
         base_co2  = CO..emissions.per.capita,
         base_cons = Consumption.based.CO..emissions.per.capita)

df_dec <- df_dec_raw |>
  left_join(base_1990, by = "land_de") |>
  mutate(
    idx_gdp  = (GDP.per.capita                              / base_gdp  - 1) * 100,
    idx_co2  = (CO..emissions.per.capita                   / base_co2  - 1) * 100,
    # Konsumbasiert nur für Nicht-Welt sinnvoll (für Welt gilt: territorial = konsumbasiert)
    idx_cons = ifelse(land_de == "Welt", NA_real_,
                      (Consumption.based.CO..emissions.per.capita / base_cons - 1) * 100)
  ) |>
  pivot_longer(
    cols      = c(idx_gdp, idx_co2, idx_cons),
    names_to  = "Variable",
    values_to = "Wert"
  ) |>
  filter(!is.na(Wert)) |>
  mutate(
    Variable = factor(
      dplyr::case_match(Variable,
        "idx_gdp"  ~ "BIP pro Kopf",
        "idx_co2"  ~ "CO₂-Emissionen pro Kopf",
        "idx_cons" ~ "Konsumbasierte CO₂-Emissionen"
      ),
      levels = c("BIP pro Kopf",
                 "CO₂-Emissionen pro Kopf",
                 "Konsumbasierte CO₂-Emissionen")
    ),
    land_de = factor(land_de,
      levels = c("Deutschland", "USA", "Welt",
                 "China",       "Indien", "Schweiz"))
  )

farben_dec <- c(
  "BIP pro Kopf"                  = "#2A5C3F",
  "CO₂-Emissionen pro Kopf"       = "#4A6B8A",
  "Konsumbasierte CO₂-Emissionen" = "#C4743B"
)

pct_label <- function(x) {
  paste0(ifelse(x > 0, "+", ""), round(x), " %")
}

p_dec <- ggplot(df_dec, aes(x = Year, y = Wert, color = Variable)) +
  geom_hline(yintercept = 0, color = mid, linewidth = 0.4) +
  geom_line(linewidth = 0.9, na.rm = TRUE) +
  facet_wrap(~ land_de, scales = "free_y", ncol = 3) +
  scale_color_manual(values = farben_dec, name = NULL) +
  scale_x_continuous(breaks = c(1990, 2000, 2010, 2024),
                     labels = c("1990", "2000", "2010", "2024"),
                     expand = expansion(mult = c(0.02, 0.02))) +
  scale_y_continuous(labels = pct_label) +
  labs(
    title    = "Veränderung von Pro-Kopf-CO₂-Emissionen und BIP seit 1990",
    subtitle = "Kumulierte Veränderung seit 1990 (Basisjahr = 0 %)",
    x        = NULL, y = NULL,
    caption  = "Quelle: Our World in Data · Eurostat, OECD, IMF, World Bank (2026) · Global Carbon Budget (2025) · CC BY"
  ) +
  theme_wachstum(base_size = 11) +
  theme(
    strip.text       = element_text(family = "playfair", face = "bold",
                                    color = ink, size = rel(1.05)),
    strip.background = element_rect(fill = "#EDE5D8", color = NA),
    panel.border     = element_rect(color = "#DDD5C5", fill = NA,
                                    linewidth = 0.4),
    legend.position  = "bottom",
    legend.key.size  = unit(0.5, "cm"),
    panel.spacing    = unit(0.8, "lines")
  )

ggsave("img/decoupling.png", p_dec, width = 9, height = 6, dpi = 150, bg = cream)
message("Gespeichert: img/decoupling.png")
