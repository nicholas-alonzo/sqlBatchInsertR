sqlBatchInserts <- function(db_conn, df, table, vals_tmpl, cols = NULL, nrows = 1000, preview = FALSE) {
  
  # retrieve parameterized "INSERT INTO" queries
  insert_queries = sqlBatchInsertsBuilder(df, table, vals_tmpl, cols, nrows, preview)
  
  if (preview == TRUE) return(insert_queries)
  
  # set up error list and begin transaction
  error_list = list()
  RODBC::odbcSetAutoCommit(db_conn, autoCommit = FALSE)
  
  for (i in seq_along(insert_queries)) {
    # retrieve any errors
    errors = RODBC::sqlQuery(db_conn, insert_queries[[i]], errors = TRUE)
    
    # populate the environment with rows affected by batch i
    name = paste("Batch", i)
    rowsaff_env[[name]] = RODBC::sqlQuery(db_conn, "SELECT @@ROWCOUNT AS RC")[["RC"]]
    
    # populate list with errors for batch i
    if (!identical(errors, character(0))) {
      name = paste("Batch", i, "Failed")
      odbc_errors = errors[grepl("Microsoft", errors)]
      error_list[[name]] = odbc_errors
    }
  }
  
  if (length(error_list) > 0) {
    # pass the error list to the error environment
    rm(list = ls(error_env), envir = error_env)
    list2env(error_list, error_env)
    # rollback and set auto commit back to default
    RODBC::odbcEndTran(db_conn, commit = FALSE)
    RODBC::odbcSetAutoCommit(db_conn, autoCommit = TRUE)
    return(-1)
  } else {    
    # calculate the total rows affected from batch inserts
    batches = ls(rowsaff_env)
    rowsaff_env$ROWCOUNT = sum(sapply(batches, get, rowsaff_env))
    # commit and set auto commit back to default
    RODBC::odbcEndTran(db_conn, commit = TRUE)
    RODBC::odbcSetAutoCommit(db_conn, autoCommit = TRUE)
    return(1)
  }
}
