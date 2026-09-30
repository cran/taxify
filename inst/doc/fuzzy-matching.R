## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(eval = FALSE)

## ----eval = TRUE, message = FALSE, warning = FALSE----------------------------
library(taxify)

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
#   "Lolium perrene",        # two edits from perenne
#   "Achillea millefolum",   # deletion: i missing
#   "Ranunculus acris"       # correct (should exact-match)
# )
# result <- taxify(messy_names)
# 
# # Check what matched and how
# result[, c("input_name", "accepted_name", "match_type", "fuzzy_dist")]

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

## ----method-table, eval = TRUE, echo = FALSE, message = FALSE, warning = FALSE----
pairs <- data.frame(
  error  = c("Single transposition", "Single deletion",
             "Single substitution", "Two transpositions"),
  input  = c("Qurecus robur", "Achillea millefolum",
             "Quarcus robur", "Qeurcus robru"),
  target = c("Quercus robur", "Achillea millefolium",
             "Quercus robur", "Quercus robur")
)
pair_dist <- function(method) {
  q <- tempfile(fileext = ".vtr")
  b <- tempfile(fileext = ".vtr")
  on.exit(unlink(c(q, b)))
  vectra::write_vtr(data.frame(qid = seq_len(nrow(pairs)), input = pairs$input), q)
  vectra::write_vtr(data.frame(bid = seq_len(nrow(pairs)), target = pairs$target), b)
  m <- vectra::collect(vectra::fuzzy_join(
    vectra::tbl(q), vectra::tbl(b),
    by = c(input = "target"), method = method, max_dist = 1
  ))
  m <- m[m$qid == m$bid, ]
  round(m$fuzzy_dist[match(seq_len(nrow(pairs)), m$qid)], 2)
}
knitr::kable(
  data.frame(pairs$error, pairs$input, pairs$target,
             pair_dist("dl"), pair_dist("levenshtein"), pair_dist("jw")),
  col.names = c("Error type", "Input", "Target", "DL dist", "Lev dist", "JW dist")
)

## ----threshold-table, eval = TRUE---------------------------------------------
nm  <- c("Poa annua", "Quercus robur", "Taraxacum officinale",
         "Achillea millefolium", "Brachypodium sylvaticum")
len <- nchar(nm)
knitr::kable(
  data.frame(nm, len, floor(len * 0.2), floor(len * 0.1), floor(len * 0.3)),
  col.names = c("Input name", "Length", "Max edits at 0.2",
                "Max edits at 0.1", "Max edits at 0.3")
)

## ----integer-threshold--------------------------------------------------------
# # Allow exactly 1 edit, regardless of name length
# result <- taxify(
#   c("Qurecus robur", "Achillea milefolium", "Poa anua"),
#   fuzzy_threshold = 1L
# )
# # "Qurecus robur" matches (1 transposition)
# # "Achillea milefolium" matches (1 deletion: ll -> l)
# # "Poa anua" matches (1 deletion: nn -> n)

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
# # "Poa pratenss" still matches (1/13 = 0.08 < 0.15)
# # "Poa trialis" fails (2/13 = 0.154 > 0.15), safer to leave unmatched

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

## ----two-pass-----------------------------------------------------------------
# # Pass 1: conservative
# pass1 <- taxify(my_names, fuzzy_threshold = 0.1)
# unmatched <- pass1$input_name[pass1$match_type == "none"]
# 
# # Pass 2: permissive, for manual review
# pass2 <- taxify(unmatched, fuzzy_threshold = 0.25)
# needs_review <- pass2[pass2$match_type == "fuzzy", ]
# needs_review[, c("input_name", "accepted_name", "fuzzy_dist")]

## ----cleaning-before-matching-------------------------------------------------
# # All three resolve to the same clean form: "Quercus robur"
# result <- taxify(c(
#   "Quercus robur L.",
#   "Quercus robur (L.) Sm.",
#   "  Quercus  robur  "
# ))
# # match_type will be "exact" for all three (no fuzzy needed)

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

