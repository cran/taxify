## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(eval = FALSE)

## ----integer-threshold--------------------------------------------------------
# # Allow exactly 1 edit, regardless of name length
# result <- taxify(
#   c("Qurecus robur", "Achillea milefolium", "Poa anua"),
#   fuzzy_threshold = 1L
# )
# # "Qurecus robur" matches (1 transposition)
# # "Achillea milefolium" matches (1 deletion: ll -> l)
# # "Poa anua" matches (1 deletion: nn -> n)

## ----cleaning-before-matching-------------------------------------------------
# # All three resolve to the same clean form: "Quercus robur"
# result <- taxify(c(
#   "Quercus robur L.",
#   "Quercus robur (L.) Sm.",
#   "  Quercus  robur  "
# ))
# # match_type will be "exact" for all three (no fuzzy needed)

## ----clean-names--------------------------------------------------------------
# clean_names <- c(
#   "Quercus robur",
#   "Pinus sylvestris",
#   "Betula pendula",
#   "Fagus sylvatica",
#   "Acer pseudoplatanus"
# )
# result <- taxify(clean_names)
# 
# # All rows have match_type == "exact"
# table(result$match_type)
# # exact
# #     5
# 
# # fuzzy_dist is NA for all rows
# all(is.na(result$fuzzy_dist))
# # TRUE

## ----clean-names-authorship---------------------------------------------------
# with_authors <- c(
#   "Quercus robur L.",
#   "Pinus sylvestris L.",
#   "Betula pendula Roth",
#   "Fagus sylvatica L.",
#   "Acer pseudoplatanus L."
# )
# result <- taxify(with_authors)
# table(result$match_type)
# # exact
# #     5

## ----ocr-degraded-------------------------------------------------------------
# messy_names <- c(
#   "Qurecus robur",         # transposition: ur -> ru
#   "Taraxacum officianle",  # transposition: al -> la
#   "Plantago lanceoalata",  # transposition: la -> al
#   "Trifolium repnes",      # transposition: en -> ne
#   "Dactylis gloemrata",    # transposition: me -> em
#   "Lolium perrene",        # insertion: extra r
#   "Achillea millefolum",   # deletion: i missing
#   "Ranunculus acris"       # correct (should exact-match)
# )
# result <- taxify(messy_names)
# 
# # Check what matched and how
# result[, c("input_name", "accepted_name", "match_type", "fuzzy_dist")]

## ----threshold-too-loose------------------------------------------------------
# # Poa is a large genus with many similar epithets
# poa_names <- c(
#   "Poa anua",       # intended: Poa annua (1 edit)
#   "Poa pratenss",   # intended: Poa pratensis (1 edit)
#   "Poa trialis"     # intended: Poa trivialis (2 edits)
# )
# 
# # With a loose threshold, some may match the wrong species
# loose <- taxify(poa_names, fuzzy_threshold = 0.4)
# loose[, c("input_name", "accepted_name", "fuzzy_dist")]

## ----threshold-tightened------------------------------------------------------
# tight <- taxify(poa_names, fuzzy_threshold = 0.15)
# tight[, c("input_name", "accepted_name", "match_type", "fuzzy_dist")]
# # "Poa anua" still matches (1/9 = 0.11 < 0.15)
# # "Poa pratenss" still matches (1/12 = 0.08 < 0.15)
# # "Poa trialis" may fail (2/11 = 0.18 > 0.15), safer to leave unmatched

## ----compare-methods----------------------------------------------------------
# test_names <- c(
#   "Qurecus robur",        # transposition in genus
#   "Achillea milefolium",  # deletion (l dropped)
#   "Plantago lanceoalata", # transposition in epithet
#   "Betula pednula",       # transposition in epithet
#   "Fagus sylvatcia"       # transposition in epithet
# )
# 
# dl_result  <- taxify(test_names, fuzzy_method = "dl")
# lev_result <- taxify(test_names, fuzzy_method = "levenshtein")
# jw_result  <- taxify(test_names, fuzzy_method = "jw")
# 
# # Compare fuzzy_dist across methods
# comparison <- data.frame(
#   input = test_names,
#   dl_dist  = dl_result$fuzzy_dist,
#   lev_dist = lev_result$fuzzy_dist,
#   jw_dist  = jw_result$fuzzy_dist,
#   dl_match  = dl_result$match_type,
#   lev_match = lev_result$match_type,
#   jw_match  = jw_result$match_type
# )
# comparison

## ----fuzzy-dist-filter--------------------------------------------------------
# result <- taxify(my_species_list)
# 
# # High-confidence fuzzy matches (likely just typos)
# good_fuzzy <- result[result$match_type == "fuzzy" &
#                      result$fuzzy_dist < 0.1, ]
# 
# # Questionable fuzzy matches (review manually)
# check_fuzzy <- result[result$match_type == "fuzzy" &
#                       result$fuzzy_dist >= 0.1, ]

## ----sort-by-dist-------------------------------------------------------------
# fuzzy_rows <- result[result$match_type == "fuzzy", ]
# fuzzy_rows <- fuzzy_rows[order(-fuzzy_rows$fuzzy_dist), ]
# head(fuzzy_rows[, c("input_name", "accepted_name", "fuzzy_dist")], 20)

## ----disable-fuzzy------------------------------------------------------------
# result <- taxify(curated_list, fuzzy = FALSE)

## ----tight-threshold----------------------------------------------------------
# result <- taxify(short_grass_list, fuzzy_threshold = 0.1)

## ----loose-threshold----------------------------------------------------------
# result <- taxify(ocr_names, fuzzy_threshold = 0.25)
# # Then filter questionable matches:
# suspect <- result[result$fuzzy_dist > 0.15, ]

## ----integer-threshold-uniform------------------------------------------------
# # Uniform 2-edit budget, regardless of name length
# result <- taxify(my_names, fuzzy_threshold = 2L)

## ----two-pass-----------------------------------------------------------------
# # Pass 1: conservative
# pass1 <- taxify(my_names, fuzzy_threshold = 0.1)
# unmatched <- pass1$input_name[pass1$match_type == "none"]
# 
# # Pass 2: permissive, for manual review
# pass2 <- taxify(unmatched, fuzzy_threshold = 0.25)
# needs_review <- pass2[pass2$match_type == "fuzzy", ]
# needs_review[, c("input_name", "accepted_name", "fuzzy_dist")]

