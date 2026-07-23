## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE
)

## -----------------------------------------------------------------------------
# library(taxify)
# 
# # a small regional list, with a couple of misspellings to correct
# field_names <- c(
#   "Gentiana acaulis", "Primula veris", "Pulsatilla vulgaris",
#   "Gentiana acaulary", "Primula elatour"
# )

## -----------------------------------------------------------------------------
# taxify("Gentiana acaulis", region = "Europe")

## -----------------------------------------------------------------------------
# taxify(field_names, region = c("Belgium", "Netherlands", "Germany"))

## -----------------------------------------------------------------------------
# # Brussels: c(longitude, latitude)
# taxify(field_names, coords = c(4.35, 50.85))

## -----------------------------------------------------------------------------
# occ <- data.frame(
#   lon = c(4.35, 5.12, 4.40),
#   lat = c(50.85, 51.21, 50.50)
# )
# taxify(field_names, coords = occ)

## -----------------------------------------------------------------------------
# # only count regions where WCVP lists the species as native
# taxify(field_names, region = "Europe", range = "native")
# 
# # only introduced occurrences
# taxify(field_names, region = "Europe", range = "introduced")

## -----------------------------------------------------------------------------
# taxify_regions("Belgium")

## -----------------------------------------------------------------------------
# # every code Europe expands to
# nrow(taxify_regions("Europe"))
# #> [1] 41
# 
# # browse the full table
# head(taxify_regions())

## -----------------------------------------------------------------------------
# taxify(c("Carcinus maenus", "Gadus morhua"), region = "North Sea")

## -----------------------------------------------------------------------------
# head(taxify_regions("Temperate Northern Atlantic", scheme = "meow"))

## -----------------------------------------------------------------------------
# # central North Sea
# taxify(field_names, coords = c(3.0, 56.0))

