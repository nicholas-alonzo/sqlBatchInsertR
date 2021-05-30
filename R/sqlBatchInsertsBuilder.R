sqlBatchInsertsBuilder <- function(df, table, vals_tmpl, cols = NULL, nrows = 1000, preview = FALSE) {
  
  # filter data frame by specified columns if provided
  if(!is.null(cols)) df = df[, cols, drop = FALSE]
  
  # identify numeric and character columns
  numeric_cols = names(which(sapply(df, is.numeric)))
  character_cols = names(which(sapply(df, is.character)))
  
  # change numeric columns to character 
  # change NA values of numeric columns to single quotes 
  df[, numeric_cols] = sapply(df[, numeric_cols], as.character)
  df[, numeric_cols][is.na(df[, numeric_cols])] <- "''"
  
  # change NA values of character columns to empty string
  df[, character_cols][is.na(df[, character_cols])] <- ""
  
  # sprintf over data frame values using flattened values template
  flattened_vals_tmpl = gsub("\n|\\s+", " ", vals_tmpl)
  flattened_vals_tmpl = gsub("\\?", "%s", flattened_vals_tmpl)
  values = tryCatch({
    do.call(sprintf, c(flattened_vals_tmpl, df))
  }, error = function(err) {
    err$message = "There are more placeholders than there are columns in the data frame"
    stop(err)
  })

  # create batches by number of rows
  ngroups = ceiling(length(values)/nrows)
  batches = rep(1:ngroups, each = nrows, len = length(values))
  batch_values = split(values, batches)
  
  # return first "INSERT INTO" statement
  if (preview == TRUE) {
    rows = paste(batch_values[[1]], collapse = ", ")
    insert_query = paste0("INSERT INTO ", table, " VALUES ", rows, ";")
    return(insert_query)
  }

  # return batches of "INSERT INTO" statements
  lapply(batch_values, function(values, table) {
    rows = paste(values, collapse = ", ")
    insert_queries = paste0("INSERT INTO ", table, " VALUES ", rows, ";")
    return(insert_queries)
  }, table)
}
