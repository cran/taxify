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
#   "Panthera leo",         # an animal among plants
#   "Bogusia fakensis",     # not a real genus
#   "Festuca rubra",
#   "Festuca rubra",
#   "Festuca rubraa",       # one stray letter
#   "Pinus sylvestris",
#   "Pinus abies"           # a synonym of Picea abies
# )
# 
# inspect(names)

## -----------------------------------------------------------------------------
# inspect(names, backbones = TRUE)

## -----------------------------------------------------------------------------
# taxify(names, backend = c("wfo", "gbif")) |>
#   inspect()

## -----------------------------------------------------------------------------
# alpine <- taxify(c("Gentiana lutea", "Primula veris", "Banksia serrata")) |>
#   inspect(region = "Europe")

## -----------------------------------------------------------------------------
# # only names that need a decision or a second look
# inspect(names, backbones = TRUE, min_tier = "review")

## -----------------------------------------------------------------------------
# inspect("Quercus robber", backbones = TRUE)
# #> Warning: list-context anomaly checks need a batch of names; with a single
# #> name only the per-name checks run.

## -----------------------------------------------------------------------------
# report <- inspect(names, backbones = TRUE)
# 
# # the names that came back with a confident replacement
# fixes <- report[!is.na(report$suggestion), c("input_name", "suggestion")]
# fixes

