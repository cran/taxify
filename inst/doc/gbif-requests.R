## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE
)

## -----------------------------------------------------------------------------
# library(taxify)
# 
# spp <- c("Quercus robur", "Pinus sylvestris", "Bellis perennis", "Morus alba")

## -----------------------------------------------------------------------------
# matched <- taxify(spp, backbone = "gbif")   # resolve the names to GBIF keys
# dl      <- gbif_request(matched)            # ask GBIF for every key
# recs    <- gbif_fetch(dl)                   # wait, download, attach the input names
# cite(recs)                                  # the download's DOI

## -----------------------------------------------------------------------------
# matched <- taxify(spp, backbone = "gbif")
# 
# matched[, c("input_name", "accepted_name", "accepted_id", "taxonomic_status", "n_ids")]
# #>         input_name    accepted_name accepted_id taxonomic_status n_ids
# #> 1    Quercus robur    Quercus robur     2878688         ACCEPTED     3
# #> 2 Pinus sylvestris Pinus sylvestris     5285637         ACCEPTED     6
# #> 3  Bellis perennis  Bellis perennis     3117424         ACCEPTED     1
# #> 4       Morus alba       Morus alba     5361889         ACCEPTED     1
# #> Sources: GBIF 2023.08 | cite() for full citations

## -----------------------------------------------------------------------------
# dl   <- gbif_request(matched)
# recs <- gbif_fetch(dl)

## -----------------------------------------------------------------------------
# dl   <- gbif_request(spp)   # match, then ask GBIF for every key
# recs <- gbif_fetch(dl)      # wait, download, import, attach the input names

## -----------------------------------------------------------------------------
# gbif_request(spp, dry_run = TRUE)
# #> 11 GBIF key(s) from 4 matched name(s). About 4,090,085 occurrence record(s) across them.
# #>  [1] 2878688 7911626 7586523 5285637 7718215 8116613 9079676 8251433 7393648
# #> [10] 3117424 5361889

## -----------------------------------------------------------------------------
# taxify(spp, backbone = "gbif") |>
#   taxify_ids()
# #>          input_name accepted_id    accepted_name taxonomic_status n_occurrences is_pick
# #> 1     Quercus robur     2878688    Quercus robur         ACCEPTED       1725528    TRUE
# #> 2     Quercus robur     7911626    Quercus robur         DOUBTFUL             2   FALSE
# #> 3     Quercus robur     7586523    Quercus robur         DOUBTFUL             9   FALSE
# #> 4  Pinus sylvestris     5285637 Pinus sylvestris         ACCEPTED       1204947    TRUE
# #> 5  Pinus sylvestris     7718215 Pinus sylvestris         DOUBTFUL             0   FALSE
# #> 6  Pinus sylvestris     8116613 Pinus sylvestris         DOUBTFUL             0   FALSE
# #> 7  Pinus sylvestris     9079676 Pinus sylvestris         DOUBTFUL             0   FALSE
# #> 8  Pinus sylvestris     8251433 Pinus sylvestris         DOUBTFUL             0   FALSE
# #> 9  Pinus sylvestris     7393648 Pinus sylvestris         DOUBTFUL             0   FALSE
# #> 10  Bellis perennis     3117424  Bellis perennis         ACCEPTED       1107989    TRUE
# #> 11       Morus alba     5361889       Morus alba         ACCEPTED         51610    TRUE

## -----------------------------------------------------------------------------
# gbif_request(spp, strict = TRUE, dry_run = TRUE)
# #> 4 GBIF key(s) from 4 matched name(s). About 4,090,074 occurrence record(s) across them.
# #> [1] 2878688 5285637 3117424 5361889

## -----------------------------------------------------------------------------
# install.packages("rgbif")

## -----------------------------------------------------------------------------
# usethis::edit_r_environ()

## -----------------------------------------------------------------------------
# rgbif::occ_download_list(limit = 5)

## -----------------------------------------------------------------------------
# recs <- gbif_request(spp, method = "search", strict = TRUE, limit = 50)
# nrow(recs)
# #> [1] 200

## -----------------------------------------------------------------------------
# dl <- gbif_request(spp, method = "download")
# recs <- gbif_fetch(dl)

## -----------------------------------------------------------------------------
# dl <- gbif_request(long_species_list, method = "download")
# #> 2431 keys exceed GBIF's query limit; splitting into 3 downloads of up to
# #> 1000 keys. Each gets its own DOI.

## -----------------------------------------------------------------------------
# recs <- gbif_fetch(dl)

## -----------------------------------------------------------------------------
# recs <- gbif_request(spp, method = "search", limit = 100)
# recs <- gbif_backmatch(recs, recs)
# 
# table(recs$input_name, useNA = "ifany")

## -----------------------------------------------------------------------------
# recs <- gbif_fetch(dl, backmatch = FALSE)
# recs <- gbif_backmatch(recs, dl)

## -----------------------------------------------------------------------------
# matched <- taxify(spp, backbone = "gbif")
# recs <- gbif_backmatch(recs, matched)

## -----------------------------------------------------------------------------
# recs <- gbif_fetch(dl)
# 
# cite(recs)
# #> ── taxify citations ────────────────────────────────────────────────
# #>   [1] Colling G (2026). taxify: Offline Taxonomic Name Matching (version 0.6.0).
# #>   [2] GBIF Secretariat (2024). GBIF Backbone Taxonomy. doi:10.15468/39omei
# #>   [3] GBIF.org (2026-09-23) GBIF Occurrence Download https://doi.org/10.15468/dl.ckzs32
# #>   ────────────────────────────────────────────────────────────

## -----------------------------------------------------------------------------
# taxify(spp) |>
#   gbif_request(dry_run = TRUE)
# #> No rows matched by GBIF; re-matching the names against the GBIF backbone, whose keys a GBIF request needs.
# #> 11 GBIF key(s) from 4 matched name(s). About 4,090,085 occurrence record(s) across them.
# #>  [1] 2878688 7911626 7586523 5285637 7718215 8116613 9079676 8251433 7393648
# #> [10] 3117424 5361889

## -----------------------------------------------------------------------------
# taxify(spp, backbone = "gbif", kingdom = "Plantae") |>
#   gbif_request()

