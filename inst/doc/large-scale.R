## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE
)
library(taxify)

## -----------------------------------------------------------------------------
# taxify_data_dir()
# #> [1] "C:/Users/jane/AppData/Local/R/taxify"

## -----------------------------------------------------------------------------
# # Assume `species_list` is a character vector of 10,000 plant names
# 
# # Exact + fuzzy (default)
# t_fuzzy <- system.time(
#   result_fuzzy <- taxify(species_list, backbone = "wfo", fuzzy = TRUE)
# )
# 
# # Exact only
# t_exact <- system.time(
#   result_exact <- taxify(species_list, backbone = "wfo", fuzzy = FALSE)
# )
# 
# t_fuzzy["elapsed"]
# t_exact["elapsed"]

## -----------------------------------------------------------------------------
# # Pass 1: exact only
# result <- taxify(species_list, backbone = "wfo", fuzzy = FALSE)
# 
# # How many names remain unmatched?
# n_unmatched <- sum(result$match_type == "none")
# message(n_unmatched, " names unmatched after exact pass")
# 
# # Pass 2: fuzzy only on the unmatched subset
# if (n_unmatched > 0) {
#   unmatched_names <- result$input_name[result$match_type == "none"]
#   fuzzy_result <- taxify(unmatched_names, backbone = "wfo", fuzzy = TRUE)
# 
#   # Merge back
#   matched_rows <- fuzzy_result$match_type != "none"
#   idx <- match(fuzzy_result$input_name[matched_rows],
#                result$input_name)
#   result[idx, ] <- fuzzy_result[matched_rows, ]
# }

## -----------------------------------------------------------------------------
# # 8,000 names: ~6,000 plants, ~1,500 fish, ~500 invertebrates
# t_wfo_first <- system.time(
#   result_a <- taxify(survey_names,
#                      backbone = c("wfo", "col"),
#                      fuzzy = TRUE)
# )
# t_wfo_first["elapsed"]
# 
# # Reversed order: COL first, WFO second
# t_col_first <- system.time(
#   result_b <- taxify(survey_names,
#                      backbone = c("col", "wfo"),
#                      fuzzy = TRUE)
# )
# t_col_first["elapsed"]

## -----------------------------------------------------------------------------
# # Match names
# result <- taxify(species_list, backbone = "gbif")
# 
# # Save result
# saveRDS(result, "matched_names.rds")
# 
# # Free the backbone from memory
# taxify_clear_cache()
# 
# gc()

## -----------------------------------------------------------------------------
# # 300,000 names from a herbarium digitization project
# all_names <- readLines("herbarium_names.txt")
# chunk_size <- 50000
# 
# # Split into chunks
# chunks <- split(all_names,
#                 ceiling(seq_along(all_names) / chunk_size))
# 
# # Process each chunk
# results <- lapply(seq_along(chunks), function(i) {
#   message(sprintf("Chunk %d/%d (%d names)...",
#                   i, length(chunks), length(chunks[[i]])))
#   taxify(chunks[[i]], backbone = "wfo", fuzzy = TRUE, verbose = FALSE)
# })
# 
# # Combine
# result <- do.call(rbind, results)
# nrow(result)
# #> [1] 300000

## -----------------------------------------------------------------------------
# output_dir <- "results"
# dir.create(output_dir, showWarnings = FALSE)
# 
# for (i in seq_along(chunks)) {
#   message(sprintf("Chunk %d/%d", i, length(chunks)))
#   res <- taxify(chunks[[i]], backbone = "wfo",
#                 fuzzy = TRUE, verbose = FALSE)
#   saveRDS(res, file.path(output_dir,
#                          sprintf("chunk_%04d.rds", i)))
# }
# 
# # Combine when needed
# all_files <- list.files(output_dir, pattern = "\\.rds$",
#                         full.names = TRUE)
# result <- do.call(rbind, lapply(all_files, readRDS))

## -----------------------------------------------------------------------------
# for (i in seq_along(chunks)) {
#   out_file <- file.path(output_dir, sprintf("chunk_%04d.rds", i))
#   if (file.exists(out_file)) next
#   message(sprintf("Chunk %d/%d", i, length(chunks)))
#   res <- taxify(chunks[[i]], backbone = "wfo",
#                 fuzzy = TRUE, verbose = FALSE)
#   saveRDS(res, out_file)
# }

## -----------------------------------------------------------------------------
# # After finishing all matching work
# taxify_clear_cache()
# gc()

## -----------------------------------------------------------------------------
# taxify_refresh_manifest()

## -----------------------------------------------------------------------------
# # Total size of all backbones and enrichments
# data_dir <- taxify_data_dir()
# files <- list.files(data_dir, recursive = TRUE, full.names = TRUE)
# total_mb <- sum(file.size(files), na.rm = TRUE) / 1048576
# message(sprintf("taxify data: %.0f MB across %d files",
#                 total_mb, length(files)))

## -----------------------------------------------------------------------------
# # Remove GBIF backbone (frees ~500-700 MB)
# unlink(file.path(taxify_data_dir(), "gbif"), recursive = TRUE)
# 
# # Clear the session cache so taxify() doesn't try to use the old path
# taxify_clear_cache()

## -----------------------------------------------------------------------------
# # Pre-download everything needed for a multi-kingdom analysis
# # with conservation status and trait enrichments
# 
# # Backbones
# taxify_download(c("col", "wfo"))
# 
# # Enrichments
# taxify_download_enrichment(c(
#   "iucn",
#   "zanne",
#   "eive",
#   "elton_traits"
# ))
# 
# # Now the analysis can run fully offline
# result <- taxify(species_list, backbone = c("col", "wfo"))
# result <- add_iucn(result)
# result <- add_zanne(result)

## -----------------------------------------------------------------------------
# list_enrichments()
# #>                name version    nrow static
# #> 1 iucn 2026.04   59583  FALSE
# #> 2               griis 2026.04   98131  FALSE
# #> 3                wcvp 2026.04 1973234  FALSE
# #> 4                eive     1.0   14835   TRUE
# #> 5        elton_traits     1.0   15394   TRUE
# #> 6              avonet     1.0   11009   TRUE
# #> ...

## -----------------------------------------------------------------------------
# # Pattern for 500,000+ names with enrichments
# for (i in seq_along(chunks)) {
#   res <- taxify(chunks[[i]], backbone = "wfo",
#                 fuzzy = TRUE, verbose = FALSE)
#   res <- add_iucn(res, verbose = FALSE)
#   res <- add_zanne(res, verbose = FALSE)
#   saveRDS(res, sprintf("results/chunk_%04d.rds", i))
# }

## -----------------------------------------------------------------------------
# # Tight threshold for clean input
# result <- taxify(clean_names, backbone = "col",
#                  fuzzy = TRUE, fuzzy_threshold = 0.1)
# 
# # Integer threshold: at most 2 edits, period
# result <- taxify(noisy_names, backbone = "col",
#                  fuzzy = TRUE, fuzzy_threshold = 2L)

