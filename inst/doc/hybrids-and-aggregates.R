## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE
)

## -----------------------------------------------------------------------------
# library(taxify)

## -----------------------------------------------------------------------------
# names <- c(
#   "Quercus robur",
#   "Mentha x piperita",
#   "x Cupressocyparis leylandii",
#   "Salix alba x Salix fragilis",
#   "Platanus x hispanica"
# )
# 
# result <- taxify(names, backbone = "wfo")
# result[, c("input_name", "accepted_name", "is_hybrid", "hybrid_type", "match_type")]

## -----------------------------------------------------------------------------
# result |> add_hybrid_info()

## -----------------------------------------------------------------------------
# formulas <- c(
#   "Salix alba x Salix fragilis",
#   "Quercus pyrenaica x Q. petraea",
#   "Populus nigra x Populus deltoides",
#   "Rosa canina x R. gallica"
# )
# 
# formula_result <- taxify(formulas, backbone = "wfo")
# formula_result <- formula_result |> add_hybrid_info()
# 
# formula_result[, c("input_name", "hybrid_type",
#                     "hybrid_parent_1", "hybrid_parent_2")]

## -----------------------------------------------------------------------------
# info <- result |> add_hybrid_info()
# formula_rows <- info[!is.na(info$hybrid_type) & info$hybrid_type == "formula", ]
# formula_rows[, c("input_name", "hybrid_parent_1", "hybrid_parent_1_accepted",
#                  "hybrid_parent_2", "hybrid_parent_2_accepted")]

## -----------------------------------------------------------------------------
# # A hybrid formula with no direct trait record inherits from its parents
# taxify("Salix alba x Salix fragilis", backbone = "wfo") |>
#   add_trait("plant_height")

## -----------------------------------------------------------------------------
# # Authorship is stripped; hybrid detection still works
# taxify("Mentha x piperita L.", backbone = "wfo")

## -----------------------------------------------------------------------------
# agg_names <- c(
#   "Rubus fruticosus agg.",
#   "Taraxacum officinale agg.",
#   "Galium mollugo s.l.",
#   "Quercus robur"
# )
# 
# res <- taxify(agg_names, backbone = "wfo")
# res[, c("input_name", "accepted_name", "qualifier",
#         "aggregate_fallback", "match_type")]

## -----------------------------------------------------------------------------
# # Rubus fruticosus agg. takes the aggregate's trait where the source records
# # one, otherwise the nominal Rubus fruticosus value.
# taxify("Rubus fruticosus agg.") |>
#   add_trait("plant_height")

## -----------------------------------------------------------------------------
# taxify("Rubus fruticosus agg.") |>
#   add_trait("plant_height", aggregate_trait_fallback = FALSE)
# 
# options(taxify.aggregate_trait_fallback = FALSE)

