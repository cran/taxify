## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE
)

## -----------------------------------------------------------------------------
# library(taxify)

## -----------------------------------------------------------------------------
# # Download the WFO backbone (~150 MB)
# taxify_download_vtr("wfo")

## -----------------------------------------------------------------------------
# taxify_data_dir()

## -----------------------------------------------------------------------------
# taxify_download_vtr(c("wfo", "col", "gbif"))

## -----------------------------------------------------------------------------
# result <- taxify(c(
#   "Quercus robur",
#   "Pinus sylvestris",
#   "Betula pendula",
#   "Fagus sylvatica",
#   "Acer pseudoplatanus"
# ))

## -----------------------------------------------------------------------------
# result[, c("input_name", "accepted_name", "family", "match_type")]

## -----------------------------------------------------------------------------
# row <- taxify("Pinus abies")
# t(row)

## -----------------------------------------------------------------------------
# messy_result <- taxify(c(
#   "Quercus robur L.",              # trailing authorship
#   "cf. Betula pendula",            # qualifier prefix
#   "Pinus sylvestris var. hamata",  # infraspecific qualifier
#   "  Fagus   sylvatica  ",         # extra whitespace
#   "ACER PSEUDOPLATANUS"            # all caps
# ))
# 
# messy_result[, c("input_name", "accepted_name", "match_type")]

## -----------------------------------------------------------------------------
# syn_result <- taxify(c(
#   "Picea abies",
#   "Pinus abies",       # basionym / synonym of Picea abies
#   "Quercus robur",
#   "Quercus pedunculata" # synonym of Quercus robur
# ))
# 
# syn_result[, c("input_name", "matched_name", "accepted_name", "is_synonym")]

## -----------------------------------------------------------------------------
# spruce <- taxify(c(
#   "Picea abies",       # accepted name
#   "Pinus abies",       # Linnaean basionym
#   "Abies picea",       # Miller's combination
#   "Picea excelsa"      # Link's combination
# ))
# 
# spruce[, c("input_name", "accepted_name", "accepted_id", "is_synonym")]

## -----------------------------------------------------------------------------
# taxify("Quercus robur")[, c("input_name", "match_type", "fuzzy_dist")]

## -----------------------------------------------------------------------------
# taxify("quercus robur")[, c("input_name", "match_type", "fuzzy_dist")]

## -----------------------------------------------------------------------------
# taxify("Quercus robor")[, c("input_name", "accepted_name",
#                             "match_type", "fuzzy_dist")]

## -----------------------------------------------------------------------------
# taxify("Panthera leo")[, c("input_name", "match_type", "life_form")]

## -----------------------------------------------------------------------------
# taxify("Fakegenus fakus")[, c("input_name", "match_type")]

## -----------------------------------------------------------------------------
# types_result <- taxify(c(
#   "Quercus robur",      # exact
#   "quercus robur",      # exact_ci (case folding)
#   "Quercus robor",      # fuzzy (one-char typo)
#   "Panthera leo",       # out_of_scope (animal in WFO)
#   "Fakegenus fakus"     # none
# ))
# 
# table(types_result$match_type)

## -----------------------------------------------------------------------------
# # Strict: only allow 1 edit total, regardless of name length
# taxify("Quercus robor", fuzzy_threshold = 1L)
# 
# # Jaro-Winkler instead of Damerau-Levenshtein
# taxify("Quercus robor", fuzzy_method = "jw")
# 
# # No fuzzy matching at all
# taxify("Quercus robor", fuzzy = FALSE)

## -----------------------------------------------------------------------------
# mixed <- taxify(c(
#   "Quercus robur", "Pinus sylvestris", "Betula pendula",
#   "Picea abies", "Pinus abies",
#   "Quercus robor",       # typo
#   "Panthera leo",         # animal in WFO
#   "Felis catus",          # animal in WFO
#   "Fakus invalidus"       # genuinely absent
# ))
# 
# summary(mixed)

## -----------------------------------------------------------------------------
# enriched <- mixed |>
#   add_conservation_status() |>
#   add_woodiness()
# 
# summary(enriched)

## -----------------------------------------------------------------------------
# multi <- taxify(
#   c("Quercus robur", "Panthera leo", "Amanita muscaria",
#     "Escherichia coli", "Salmo trutta"),
#   backend = c("wfo", "col", "gbif")
# )

## -----------------------------------------------------------------------------
# multi[, c("input_name", "accepted_name", "backend")]

## -----------------------------------------------------------------------------
# list_enrichments()

## -----------------------------------------------------------------------------
# conservation <- taxify(c(
#   "Panthera tigris",
#   "Quercus robur",
#   "Ailuropoda melanoleuca",
#   "Pinus sylvestris",
#   "Spheniscus demersus"
# ), backend = c("wfo", "col")) |>
#   add_conservation_status()
# 
# conservation[, c("input_name", "accepted_name", "conservation_status")]

## -----------------------------------------------------------------------------
# common <- taxify(c(
#   "Quercus robur",
#   "Pinus sylvestris",
#   "Betula pendula"
# )) |>
#   add_common_names()
# 
# common[, c("input_name", "common_name")]

## -----------------------------------------------------------------------------
# common_de <- taxify(c(
#   "Quercus robur",
#   "Pinus sylvestris",
#   "Betula pendula"
# )) |>
#   add_common_names(lang = "de")
# 
# common_de[, c("input_name", "common_name")]

## -----------------------------------------------------------------------------
# woody <- taxify(c(
#   "Quercus robur",
#   "Trifolium repens",
#   "Salix caprea",
#   "Plantago lanceolata"
# )) |>
#   add_woodiness()
# 
# woody[, c("input_name", "accepted_name", "woodiness")]

## -----------------------------------------------------------------------------
# stacked <- taxify(c(
#   "Quercus robur",
#   "Betula pendula",
#   "Pinus sylvestris"
# )) |>
#   add_conservation_status() |>
#   add_woodiness() |>
#   add_common_names()
# 
# stacked[, c("accepted_name", "conservation_status",
#             "woodiness", "common_name")]

## -----------------------------------------------------------------------------
# traits <- data.frame(
#   species = c("Quercus robur", "Quercus pedunculata",
#               "Pinus sylvestris", "Betula pendula"),
#   max_height_m = c(40, 40, 35, 25),
#   shade_tolerance = c("moderate", "moderate", "intolerant", "intolerant"),
#   stringsAsFactors = FALSE
# )
# 
# result <- taxify(c("Quercus robur", "Pinus sylvestris", "Betula pendula"))
# 
# enriched <- result |>
#   add_data(traits, species_col = "species")

## -----------------------------------------------------------------------------
# enriched[, c("input_name", "accepted_name", "max_height_m", "shade_tolerance")]

## -----------------------------------------------------------------------------
# enriched <- result |>
#   add_data("my_field_traits.csv")

## -----------------------------------------------------------------------------
# # SQLite
# result |> add_data("ecology_db.sqlite", table = "plant_traits")
# 
# # XLSX
# result |> add_data("supplementary_table_S1.xlsx", species_col = "Taxon")
# 
# # Subset columns
# result |> add_data(traits, species_col = "species", cols = "max_height_m")

## -----------------------------------------------------------------------------
# hybrids <- taxify(c(
#   "Quercus x rosacea",                  # nothospecies
#   "Quercus pyrenaica x Q. petraea",     # hybrid formula
#   "x Cuprocyparis leylandii",           # nothogenus
#   "Betula pendula"                       # not a hybrid
# )) |>
#   add_hybrid_info()
# 
# hybrids[, c("input_name", "is_hybrid", "hybrid_type",
#             "hybrid_parent_1", "hybrid_parent_2")]

## -----------------------------------------------------------------------------
# lookup_genus("Quercus")

## -----------------------------------------------------------------------------
# lookup_genus("Panthera")

## -----------------------------------------------------------------------------
# taxify_register_coverage("Quercus")

## -----------------------------------------------------------------------------
# taxify_register_coverage("Panthera")

## -----------------------------------------------------------------------------
# taxify_clear_cache()

## -----------------------------------------------------------------------------
# taxify_refresh_manifest()

## -----------------------------------------------------------------------------
# # See where everything lives
# taxify_data_dir()
# 
# # To remove all taxify data (backbones, enrichments, register):
# # unlink(taxify_data_dir(), recursive = TRUE)

## -----------------------------------------------------------------------------
# survey_names <- c(
#   "Quercus robur", "Fagus sylvatica", "Betula pendula",
#   "Pinus sylvestris", "Alnus glutinosa", "Fraxinus excelsior",
#   "Pinus abies", "Quercus pedunculata", "Picea excelsa",
#   "Quercus robor", "Fagus sylvatyca",
#   "cf. Sorbus aucuparia", "Acer pseudoplatanus L.",
#   "Pinus sylvestris var. hamata", "  Tilia   cordata  ",
#   "Quercus x rosacea",
#   "Panthera leo", "Salmo trutta", "Cervus elaphus", "Parus major",
#   "Notareal plantus", "Randomus specius"
# )

## -----------------------------------------------------------------------------
# result <- taxify(survey_names, backend = c("wfo", "col"))

## -----------------------------------------------------------------------------
# summary(result)

## -----------------------------------------------------------------------------
# result <- result |>
#   add_conservation_status() |>
#   add_woodiness() |>
#   add_common_names()

## -----------------------------------------------------------------------------
# summary(result)

## -----------------------------------------------------------------------------
# analysis <- result[, c("input_name", "accepted_name", "family",
#                         "match_type", "is_synonym", "backend",
#                         "conservation_status", "woodiness",
#                         "common_name")]

## -----------------------------------------------------------------------------
# # Which names were synonyms?
# result[result$is_synonym == TRUE,
#        c("input_name", "accepted_name", "accepted_id")]

## -----------------------------------------------------------------------------
# # Which names needed fuzzy correction?
# result[result$match_type == "fuzzy",
#        c("input_name", "accepted_name", "fuzzy_dist")]

## -----------------------------------------------------------------------------
# # Threatened species in the survey
# result[!is.na(result$conservation_status) &
#        result$conservation_status %in% c("VU", "EN", "CR"),
#        c("accepted_name", "conservation_status", "common_name")]

## -----------------------------------------------------------------------------
# # Woody vs. herbaceous breakdown
# table(result$woodiness, useNA = "ifany")

