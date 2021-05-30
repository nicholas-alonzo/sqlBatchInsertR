sqlBatchInsertsBuilder <- function(df, table, vals_tmpl, nrows = 1000) {
  
  # compare no of placeholders to no of columns in data frame
  nplaceholders = lengths(regmatches(vals_tmpl, gregexpr("\\?", vals_tmpl)))
  if(nplaceholders > ncol(df)) {
    stop("There are more placeholders than specified columns in the data frame")
  }
  
  # identify non character columns and cast to character
  # change NA values to NULL
  non_character_cols = names(df)[!sapply(df, is.character)]
  df[, non_character_cols] = sapply(df[, non_character_cols], as.character)
  df[is.na(df)] <- "NULL"
  
  # sprintf over data frame values using flattened values template
  flattened_vals_tmpl = gsub("\n|\\s+", " ", vals_tmpl)
  flattened_vals_tmpl = gsub("\\?", "%s", flattened_vals_tmpl)
  values = do.call(sprintf, c(flattened_vals_tmpl, df))

  # create batches by number of rows
  ngroups = ceiling(nrows(df)/nrows)
  batches = rep(1:ngroups, each = nrows, len = nrows(df))
  batch_values = split(values, batches)
  
  # return batches of "INSERT INTO" statements
  lapply(batch_values, function(values, table) {
    rows = paste(values, collapse = ", ")
    paste0("INSERT INTO ", table, " VALUES ", rows, ";")
  }, table)
}
