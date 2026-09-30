## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(eval = FALSE)

## ----eval = TRUE, message = FALSE, warning = FALSE----------------------------
library(taxify)

## ----download-single----------------------------------------------------------
# # Download one backbone
# taxify_download("wfo")
# 
# # Download several at once
# taxify_download(c("wfo", "col", "worms"))

## ----download-pinned----------------------------------------------------------
# taxify_download("wfo", version = "2024.01")

## ----single-wfo---------------------------------------------------------------
# plants <- c(
#   "Quercus robur",
#   "Quercus petraea",
#   "Pinus sylvestris",
#   "Acer pseudoplatanus",
#   "Betula pendula",
#   "Fagus sylvatica",
#   "Picea abies"
# )
# 
# result <- taxify(plants, backbone = "wfo")
# result[, c("input_name", "accepted_name", "family", "match_type", "backbone")]

## ----single-strict------------------------------------------------------------
# result <- taxify(plants, backbone = "wfo", fuzzy_threshold = 0.1)

## ----single-no-fuzzy----------------------------------------------------------
# result <- taxify(plants, backbone = "wfo", fuzzy = FALSE)

## ----multi-basic--------------------------------------------------------------
# mixed <- c(
#   "Quercus robur",       # plant
#   "Panthera leo",        # animal
#   "Amanita muscaria",    # fungus
#   "Salmo trutta",        # fish
#   "Escherichia coli"     # bacterium
# )
# 
# result <- taxify(mixed, backbone = c("wfo", "col", "gbif"))
# result[, c("input_name", "accepted_name", "match_type", "backbone")]

## ----plants-wfo-only----------------------------------------------------------
# plants <- c(
#   "Quercus robur",
#   "Quercus petraea",
#   "Pinus sylvestris",
#   "Acer pseudoplatanus",
#   "Coffea arabica",
#   "Welwitschia mirabilis",
#   "Lepidodendron aculeatum",   # extinct lycopsid
#   "Nothofagus cunninghamii",
#   "Dracaena draco"
# )
# 
# # WFO alone
# wfo_result <- taxify(plants, backbone = "wfo")
# table(wfo_result$match_type)

## ----plants-wfo-col-----------------------------------------------------------
# # WFO first, COL as fallback
# both_result <- taxify(plants, backbone = c("wfo", "col"))
# table(both_result$match_type)
# both_result[, c("input_name", "accepted_name", "backbone")]

## ----mixed-kingdom------------------------------------------------------------
# estuary_species <- c(
#   "Zostera marina",              # seagrass (plant)
#   "Salicornia europaea",         # glasswort (plant)
#   "Carcinus maenas",             # shore crab
#   "Mytilus edulis",              # blue mussel
#   "Platichthys flesus",          # European flounder
#   "Nereis diversicolor",         # ragworm
#   "Fucus vesiculosus",           # bladderwrack (brown alga)
#   "Littorina littorea",          # common periwinkle
#   "Arenicola marina",            # lugworm
#   "Cerastoderma edule"           # common cockle
# )
# 
# result <- taxify(estuary_species, backbone = c("col", "gbif", "worms"))
# result[, c("input_name", "accepted_name", "family", "backbone")]

## ----marine-first-------------------------------------------------------------
# result <- taxify(estuary_species, backbone = c("worms", "col"))

## ----fungi--------------------------------------------------------------------
# fungi <- c(
#   "Amanita muscaria",
#   "Boletus edulis",
#   "Cantharellus cibarius",
#   "Tuber melanosporum",
#   "Saccharomyces cerevisiae",
#   "Aspergillus niger",
#   "Penicillium chrysogenum",
#   "Agaricus bisporus",
#   "Trametes versicolor",
#   "Cordyceps militaris"
# )
# 
# result <- taxify(fungi, backbone = c("fungorum", "col"))
# result[, c("input_name", "accepted_name", "is_synonym", "backbone")]

## ----fungi-plants-mixed-------------------------------------------------------
# mixed <- c(
#   "Quercus robur",              # plant
#   "Amanita muscaria",           # fungus
#   "Lactarius deliciosus",       # fungus
#   "Pinus sylvestris",           # plant
#   "Russula emetica"             # fungus
# )
# 
# result <- taxify(mixed, backbone = c("wfo", "fungorum", "col"))

## ----algae--------------------------------------------------------------------
# algae <- c(
#   "Chlamydomonas reinhardtii",
#   "Chlorella vulgaris",
#   "Ulva lactuca",
#   "Fucus vesiculosus",
#   "Sargassum muticum"
# )
# 
# result <- taxify(algae, backbone = c("algaebase", "col"))
# result[, c("input_name", "accepted_name", "backbone")]

## ----ncbi-molecular-----------------------------------------------------------
# edna_hits <- c(
#   "Salmo trutta",
#   "Phoxinus phoxinus",
#   "Anguilla anguilla",
#   "Cottus gobio",
#   "Lampetra planeri",
#   "Chironomus riparius",     # midge (insect)
#   "Potamopyrgus antipodarum" # New Zealand mud snail
# )
# 
# result <- taxify(edna_hits, backbone = c("ncbi", "col"))
# result[, c("input_name", "accepted_name", "taxon_id", "backbone")]

## ----backbone-tally-----------------------------------------------------------
# result <- taxify(species_list, backbone = c("wfo", "col", "gbif"))
# table(result$backbone, useNA = "ifany")

## ----backbone-filter----------------------------------------------------------
# wfo_matches <- result[result$backbone == "wfo" & !is.na(result$backbone), ]
# col_matches <- result[result$backbone == "col" & !is.na(result$backbone), ]

## ----backbone-versions--------------------------------------------------------
# unique(result$backbone_version[!is.na(result$backbone_version)])
# # e.g., c("wfo:2024-12 (2026-04-01)", "col:2025 (2026-04-01)")

## ----add-wfo------------------------------------------------------------------
# result <- taxify(plants, backbone = "wfo") |>
#   add_wfo_info()
# 
# result[, c("input_name", "accepted_name", "namePublishedIn")]

## ----add-col------------------------------------------------------------------
# result <- taxify(species_list, backbone = "col") |>
#   add_col_info()
# 
# # Check which species are marine
# result[result$is_marine == TRUE & !is.na(result$is_marine),
#        c("input_name", "accepted_name", "kingdom", "is_marine")]

## ----add-gbif-----------------------------------------------------------------
# result <- taxify(species_list, backbone = "gbif") |>
#   add_gbif_info()
# 
# result[, c("input_name", "accepted_name", "origin", "nom_status")]

## ----multi-extras-------------------------------------------------------------
# result <- taxify(species_list, backbone = c("wfo", "col", "gbif")) |>
#   add_wfo_info() |>
#   add_col_info() |>
#   add_gbif_info()

## ----lookup-genus-------------------------------------------------------------
# lookup_genus("Quercus")
# #   genus   kingdom phylum class   order   family   life_form
# # 1 Quercus Plantae ...    ...     Fagales Fagaceae vascular plant

## ----lookup-genus-animal------------------------------------------------------
# lookup_genus("Panthera")
# #   genus    kingdom  phylum   class    order     family  life_form
# # 1 Panthera Animalia Chordata Mammalia Carnivora Felidae animal

## ----register-coverage--------------------------------------------------------
# taxify_register_coverage("Quercus")
# #     genus   backbone version date_added
# # 1 Quercus  col     2025    2026-04-01
# # 2 Quercus  gbif    current 2026-04-01
# # 3 Quercus  wfo     2024-12 2026-04-01

## ----out-of-scope-------------------------------------------------------------
# # Trying to match a marine invertebrate against WFO (plants only)
# result <- taxify("Carcinus maenas", backbone = "wfo")
# result$match_type
# # [1] "out_of_scope"
# 
# result$life_form
# # [1] "animal"

