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
  
  # track any NA values before manipulation
  na_positions = which(is.na(df), arr.ind = TRUE)
  
  # coerce any logical columns to integer
  logical_cols = which(vapply(df, is.logical, FUN.VALUE = logical(1)))
  if (length(logical_cols) > 0) df[, logical_cols] = as.integer(df[, logical_cols])
  
  # identify string columns 
  string_cols = which(vapply(df, function(x) {
    is.character(x) || is.factor(x) || 
      inherits(x, "Date") || inherits(x, "POSIXct") ||
      inherits(x, "POSIXlt") || inherits(x, "POSIXt")
  }, FUN.VALUE = logical(1)))
  # quote string for valid statements
  df[string_cols] = sapply(df[string_cols], function(x) {
    if (is.character(x) || is.factor(x)) {
      sQuote(gsub("'", "''", x), getOption("useFancyQuotes = FALSE"))
    } else if (inherits(x, "Date") || inherits(x, "POSIXct") ||
               inherits(x, "POSIXlt") || inherits(x, "POSIXt")) {
      sQuote(x, getOption("useFancyQuotes = FALSE"))
    }
  })
  
  # fill NA values with NULL **numeric columns are coerced to character
  if (nrow(na_positions) > 0) df[na_positions] <- "NULL"
  
  # sprintf over data frame using dynamic values template
  values_template = paste0("(", paste0(rep("%s", len = ncols), collapse = ","), ")")
  values = do.call(sprintf, c(values_template, df))
  
  # create batches by number of records
  ngroups = ceiling(nrows/nrecords)
  batches = rep(1:ngroups, each = nrecords, len = nrows)
  batch_values = split(values, batches)
  
  # return batches of INSERT statements
  lapply(batch_values, function(values) {
    records = paste0(values, collapse = ",")
    paste0("INSERT INTO ", dbtable, " VALUES ", records, ";")
  })
}
