sqlBatchInsertsBuilder <- function(df, dbtable, vals_tmpl, nrecords = 1000) {
  
  # compare no of placeholders to no of columns in data frame
  nplaceholders = lengths(regmatches(vals_tmpl, gregexpr("\\?", vals_tmpl)))
  if(nplaceholders > ncol(df)) {
    stop("There are more placeholders than columns in the data frame")
  } else if (nplaceholders < ncol(df)) {
    stop("There are less placeholders than columns in the data frame")
  }
  
  # identify column types
  character_cols = names(df)[sapply(df, is.character)]
  non_character_cols = names(df)[!sapply(df, is.character)]
  
  # update character NA values to empty string
  df[, character_cols][is.na(df[, character_cols])] <- ""
  
  # cast numeric cols to character and update NA values to NULL
  df[, non_character_cols] = sapply(df[, non_character_cols], as.character)
  df[, non_character_cols][is.na(df[, non_character_cols])] <- "NULL"
  
  # sprintf over data frame values using flattened values template
  flattened_vals_tmpl = gsub("\n|\\s+", " ", vals_tmpl)
  flattened_vals_tmpl = gsub("\\?", "%s", flattened_vals_tmpl)
  values = do.call(sprintf, c(flattened_vals_tmpl, df))

  # create batches by number of rows
  ngroups = ceiling(nrow(df)/nrecords)
  batches = rep(1:ngroups, each = nrecords, len = nrow(df))
  batch_values = split(values, batches)
  
  # return batches of "INSERT INTO" statements
  lapply(batch_values, function(values) {
    rows = paste(values, collapse = ", ")
    paste0("INSERT INTO ", dbtable, " VALUES ", rows, ";")
  })
}
