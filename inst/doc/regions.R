## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE
)

## ----eval = TRUE, message = FALSE, warning = FALSE----------------------------
library(taxify)

## -----------------------------------------------------------------------------
# field_names <- c(
#   "Gentiana acaulis", "Primula veris", "Pulsatilla vulgaris",
#   "Gentiana acaulary", "Primula elatour"
# )

## -----------------------------------------------------------------------------
# taxify(field_names, region = c("Belgium", "Netherlands", "Germany"))

## -----------------------------------------------------------------------------
# taxify("Gentiana acaulis", region = "Europe")

## -----------------------------------------------------------------------------
# # Brussels
# taxify(field_names, coords = c(4.35, 50.85))

## -----------------------------------------------------------------------------
# occ <- data.frame(
#   lon = c(4.35, 5.12, 4.40),
#   lat = c(50.85, 51.21, 50.50)
# )
# taxify(field_names, coords = occ)

## -----------------------------------------------------------------------------
# taxify(field_names, region = "Europe", range = "native")
# taxify(field_names, region = "Europe", range = "introduced")

## ----eval = TRUE--------------------------------------------------------------
taxify_regions("Belgium", scheme = "wgsrpd")

## ----eval = TRUE--------------------------------------------------------------
wgsrpd <- taxify_regions(scheme = "wgsrpd")
n_l3 <- as.data.frame(table(wgsrpd$level1_name), stringsAsFactors = FALSE)
knitr::kable(n_l3, col.names = c("Level 1 region", "Level 3 regions"))

## -----------------------------------------------------------------------------
# taxify(c("Carcinus maenus", "Gadus morhua"), region = "North Sea")

## -----------------------------------------------------------------------------
# head(taxify_regions("Temperate Northern Atlantic", scheme = "meow"))

