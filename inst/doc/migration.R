## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE
)

## ----taxify-lcvp-wcvp---------------------------------------------------------
# result <- taxify(plant_names, backend = c("wcvp", "lcvp", "wfo"))
# result[, c("input_name", "accepted_name", "backend")]

## ----taxize-basic-------------------------------------------------------------
# # --- taxize ---
# library(taxize)
# 
# names <- c("Quercus robur", "Pinus sylvestris", "Betula pendula",
#            "Panthera leo", "Salmo trutta")
# 
# resolved  <- gnr_resolve(names, best_match_only = TRUE)
# gbif_ids  <- get_gbifid(names)
# class_list <- classification(gbif_ids, db = "gbif")
# syn_list   <- synonyms(gbif_ids, db = "gbif")

## ----taxify-basic-------------------------------------------------------------
# # --- taxify ---
# library(taxify)
# 
# names <- c("Quercus robur", "Pinus sylvestris", "Betula pendula",
#            "Panthera leo", "Salmo trutta")
# 
# result <- taxify(names, backend = "gbif")
# 
# result$accepted_name
# result$family
# result$genus
# result$is_synonym
# result$taxon_id        # GBIF usage key

## ----worldflora-fuzzy---------------------------------------------------------
# # --- WorldFlora ---
# library(WorldFlora)
# 
# wfo_data <- read.delim("classification.txt")
# 
# names <- c("Quercus robur", "Quercus pedonculata",
#            "Pinus silvestris", "Rosa canina")
# matched <- WFO.match.fuzzyjoin(names, WFO.data = wfo_data)
# best    <- WFO.one(matched)

## ----taxify-fuzzy-------------------------------------------------------------
# # --- taxify ---
# library(taxify)
# 
# names <- c("Quercus robur", "Quercus pedonculata",
#            "Pinus silvestris", "Rosa canina")
# 
# result <- taxify(names, backend = "wfo")
# 
# # Misspellings are caught by fuzzy matching:
# result[, c("input_name", "matched_name", "match_type", "fuzzy_dist")]
# #   input_name           matched_name        match_type fuzzy_dist
# # 1 Quercus robur        Quercus robur       exact              NA
# # 2 Quercus pedonculata  Quercus pedunculata fuzzy           0.053
# # 3 Pinus silvestris     Pinus sylvestris    fuzzy           0.063
# # 4 Rosa canina          Rosa canina         exact              NA
# 
# # Synonyms resolved automatically:
# result[, c("input_name", "is_synonym", "accepted_name")]

## ----taxify-fallback----------------------------------------------------------
# library(taxify)
# 
# # Mixed kingdom input: plants, animals, fungi
# names <- c(
#   "Quercus robur",         # plant (WFO primary)
#   "Panthera leo",          # animal (not in WFO, picked up by GBIF)
#   "Amanita muscaria",      # fungus (not in WFO, picked up by GBIF)
#   "Salmo trutta",          # fish (not in WFO, picked up by GBIF)
#   "Arabidopsis thaliana"   # plant (in both WFO and GBIF)
# )
# 
# # WFO first (best for plants), GBIF as fallback (all kingdoms)
# result <- taxify(names, backend = c("wfo", "gbif"))
# 
# # The backend column shows which database matched each name:
# result[, c("input_name", "backend", "family")]
# #   input_name            backend family
# # 1 Quercus robur         wfo     Fagaceae
# # 2 Panthera leo          gbif    Felidae
# # 3 Amanita muscaria      gbif    Amanitaceae
# # 4 Salmo trutta          gbif    Salmonidae
# # 5 Arabidopsis thaliana  wfo     Brassicaceae
# 
# # Enrich with traits:
# result |>
#   add_iucn() |>
#   add_zanne()
# 
# # Or join custom data:
# my_traits <- data.frame(
#   species = c("Quercus robur", "Panthera leo"),
#   max_height_m = c(35, NA),
#   body_mass_kg = c(NA, 190)
# )
# result |> add_data(my_traits, species_col = "species")

## ----list-enrichments---------------------------------------------------------
# # See all available enrichments and their metadata
# list_enrichments()

