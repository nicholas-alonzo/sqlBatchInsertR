sqlBatchInsertBuilder <- function(df, dbtable, nrecords = 1000) {
  
  if (missing(df))
    stop("First argument (df) is missing")
  if (!is.data.frame(df))
    stop("First argument (df) must be a data frame")
  if (missing(dbtable))
    stop("Second argument (dbtable) is missing")
  if (!is.character(dbtable) || length(dbtable) != 1)
    stop("Second argument (dbtable) must be character(1)")
  if (!is.numeric(nrecords) || length(nrecords) != 1)
    stop("Third argument (nrecords) must be numeric(1)")
  
  # calculate number of rows and columns
  nrows = nrow(df)
  ncols = ncol(df)
  
  # create a map for numeric data types
  numeric_dtypes = c("integer", "logical", "numeric")
  dtype_mapper = function(df, dtypes) class(df) %in% dtypes
  
  # track any NA values before manipulation
  na_positions = which(is.na(df), arr.ind = TRUE)
  
  # coerce any logical columns to integer
  logical_cols = which(vapply(df, is.logical, FUN.VALUE = logical(1)))
  if (length(logical_cols) > 0) df[, logical_cols] = as.integer(df[, logical_cols])
  
  # identify string columns by negating numeric data types
  string_cols = which(!vapply(df, dtype_mapper, numeric_dtypes, FUN.VALUE = logical(1)))

  # replace single quote with 2 single quotes in string columns
  # single quote all string columns
  quote_strings = function(x) sQuote(gsub("'", "''", x), getOption("useFancyQuotes = FALSE"))
  df[string_cols] = sapply(df[string_cols], quote_strings)

  # fill NA values with NULL **numeric columns are coerced to character
  if (nrow(na_positions) > 0) df[na_positions] <- "NULL"
  
  # sprintf over data frame using dynamic values template
  vals_tmpl = paste0("(", paste0(rep("%s", len = ncols), collapse = ","), ")")
  values = do.call(sprintf, c(vals_tmpl, df))
  
  # create batches by number of records
  ngroups = ceiling(nrows/nrecords)
  batches = rep(1:ngroups, each = nrecords, len = nrows)
  batch_values = split(values, batches)
  
  # return batches of "INSERT INTO" statements
  lapply(batch_values, function(values) {
    records = paste0(values, collapse = ",")
    paste0("INSERT INTO ", dbtable, " VALUES ", records, ";")
  })
}
