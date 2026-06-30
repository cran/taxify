## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE
)

## -----------------------------------------------------------------------------
# library(taxify)

## -----------------------------------------------------------------------------
# # Our taxify result
# species <- c(
#   "Quercus robur", "Fagus sylvatica", "Picea abies",
#   "Pinus sylvestris", "Betula pendula"
# )
# result <- taxify(species, backend = "wfo")
# 
# # External trait data — note one synonym and one subspecies
# traits <- data.frame(
#   taxon = c(
#     "Quercus robur", "Fagus sylvatica", "Picea excelsa",
#     "Pinus sylvestris", "Betula pendula"
#   ),
#   sla = c(18.2, 24.1, 6.5, 8.0, 22.3),
#   max_height_m = c(35, 40, 50, 30, 25)
# )
# 
# # Join — "Picea excelsa" resolves to "Picea abies" through the backbone
# result <- result |> add_data(traits, species_col = "taxon")

## -----------------------------------------------------------------------------
# result <- taxify(species, backend = "wfo")
# result <- result |> add_data("path/to/leaf_traits.csv")

## -----------------------------------------------------------------------------
# result |> add_data("leaf_traits.csv", species_col = "latin_binomial")

## -----------------------------------------------------------------------------
# result |> add_data("global_leaf_traits.csv.gz", species_col = "species")

## -----------------------------------------------------------------------------
# # install.packages("openxlsx2")  # if not already installed
# result |> add_data("bird_morphometry.xlsx")

## -----------------------------------------------------------------------------
# # Specific sheet by name or number
# result |> add_data("bird_morphometry.xlsx", sheet = "measurements")
# result |> add_data("bird_morphometry.xlsx", sheet = 2)
# 
# # Known header row (e.g., rows 1-2 are title/notes)
# result |> add_data("bird_morphometry.xlsx", start_row = 3)
# 
# # All three specified — no scanning at all
# result |> add_data("bird_morphometry.xlsx", sheet = 1, start_row = 3,
#                    species_col = "latin_name")

## -----------------------------------------------------------------------------
# # SQLite — requires DBI and RSQLite
# result |> add_data(
#   "traits.sqlite",
#   table = "plant_traits",
#   species_col = "species"
# )

## -----------------------------------------------------------------------------
# result |> add_data("prebuilt_traits.vtr", species_col = "canonical_name")

## -----------------------------------------------------------------------------
# # Save a taxify result (with enrichments) as .vtr
# result |> export_data("processed_traits.vtr")
# 
# # A colleague can load it directly
# other_result |> add_data("processed_traits.vtr")

## -----------------------------------------------------------------------------
# result |> export_data("for_excel_users.xlsx")
# result |> export_data("for_python.csv")

## -----------------------------------------------------------------------------
# result |> add_data("leaf_traits.tsv", species_col = "species")
# result |> add_data("leaf_traits.tsv.gz")

## -----------------------------------------------------------------------------
# my_data <- readRDS("legacy_traits.rds")
# result |> add_data(my_data, species_col = "sp")

## -----------------------------------------------------------------------------
# # Auto-detection in action
# traits <- data.frame(
#   site = c("A", "A", "B", "B"),
#   species = c("Quercus robur", "Fagus sylvatica",
#               "Betula pendula", "Picea abies"),
#   habitat = c("forest", "forest", "forest edge", "boreal"),
#   sla = c(18.2, 24.1, 22.3, 6.5)
# )
# 
# # Three character columns: site, species, habitat
# # Only "species" will produce >50% backbone matches
# result |> add_data(traits)

## -----------------------------------------------------------------------------
# # Full trait table with many columns
# big_traits <- data.frame(
#   species = c("Quercus robur", "Fagus sylvatica"),
#   sla = c(18.2, 24.1),
#   max_height_m = c(35, 40),
#   leaf_nitrogen = c(2.1, 2.4),
#   wood_density = c(0.56, 0.58),
#   seed_mass_mg = c(3500, 220),
#   bark_thickness_mm = c(25, 8)
# )
# 
# # Only join SLA and wood density
# result |> add_data(big_traits, species_col = "species",
#                    cols = c("sla", "wood_density"))

## -----------------------------------------------------------------------------
# # The taxify result already has a "family" column
# # External data also has a "family" column (taxonomic family from a
# # different source) plus a "leaf_area" column
# external <- data.frame(
#   species = c("Quercus robur", "Fagus sylvatica"),
#   family = c("Fagaceae", "Fagaceae"),
#   leaf_area = c(45.2, 38.7)
# )
# 
# result |> add_data(external, species_col = "species")
# # Output gains "data_family" (from external) and "leaf_area" (no collision)

## -----------------------------------------------------------------------------
# # Harmless: same species, same values (perhaps from two sites)
# dup_ok <- data.frame(
#   species = c("Quercus robur", "Quercus robur", "Fagus sylvatica"),
#   sla = c(18.2, 18.2, 24.1)
# )
# result |> add_data(dup_ok, species_col = "species")
# # Warning: 1 duplicate rows ... deduplicated.

## -----------------------------------------------------------------------------
# # Conflicting: same species, different SLA values
# dup_bad <- data.frame(
#   species = c("Quercus robur", "Quercus robur", "Fagus sylvatica"),
#   sla = c(18.2, 21.5, 24.1)
# )
# result |> add_data(dup_bad, species_col = "species")
# # Error: 1 species resolved to the same accepted_id but have
# #   different trait values.
# #   Examples: 'Quercus robur' (wfo-0000309171)

## -----------------------------------------------------------------------------
# # Aggregate first, then join
# library(stats)
# dup_agg <- aggregate(sla ~ species, data = dup_bad, FUN = mean)
# result |> add_data(dup_agg, species_col = "species")

## -----------------------------------------------------------------------------
# # Strict: only very close matches
# result |> add_data(traits, species_col = "taxon", fuzzy_threshold = 0.1)
# 
# # Exact matching only (no fuzzy)
# result |> add_data(traits, species_col = "taxon", fuzzy = FALSE)

## -----------------------------------------------------------------------------
# result <- taxify(species, backend = "wfo") |>
#   add_conservation_status() |>
#   add_woodiness() |>
#   add_data(traits, species_col = "taxon")

