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
# result <- taxify(names, backend = "wfo")
# result[, c("input_name", "accepted_name", "is_hybrid", "match_type")]

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
# formula_result <- taxify(formulas, backend = "wfo")
# formula_result <- formula_result |> add_hybrid_info()
# 
# formula_result[, c("input_name", "hybrid_type",
#                     "hybrid_parent_1", "hybrid_parent_2")]

## -----------------------------------------------------------------------------
# # Match both parents of a hybrid formula separately
# parents <- c("Salix alba", "Salix fragilis")
# parent_result <- taxify(parents, backend = "wfo")

## -----------------------------------------------------------------------------
# # Batch-resolve all hybrid formula parents
# info <- result |> add_hybrid_info()
# formula_rows <- info[info$hybrid_type == "formula" & !is.na(info$hybrid_type), ]
# 
# all_parents <- unique(na.omit(c(
#   formula_rows$hybrid_parent_1,
#   formula_rows$hybrid_parent_2
# )))
# 
# parent_matches <- taxify(all_parents, backend = "wfo")

## -----------------------------------------------------------------------------
# # Authorship is stripped; hybrid detection still works
# taxify("Mentha x piperita L.", backend = "wfo")

