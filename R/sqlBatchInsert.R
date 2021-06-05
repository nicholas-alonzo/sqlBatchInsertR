sqlBatchInsert <- function(db_conn, df, dbtable, nrecords = 1000) {
  
  if (!RODBC:::odbcValidChannel(db_conn))
    stop("First argument (db_conn) is not an open RODBC channel")
  if (missing(df))
    stop("Second argument (df) is missing")
  if (!is.data.frame(df))
    stop("Second argument (df) must be a data frame")
  if (missing(dbtable))
    stop("Third argument (dbtable) is missing")
  if (!is.character(dbtable) || length(dbtable) != 1)
    stop("Third argument (dbtable) must be character(1)")
  if (RODBC::odbcQuery(db_conn, paste("SELECT 1 FROM", dbtable)) == -1L)
    stop(dbtable, " does not exist in the database")
  if (!is.numeric(nrecords) || length(nrecords) != 1)
    stop ("Fourth argument (nrecords) must be numeric(1)")
  
  # retrieve parameterized "INSERT INTO" statements
  batch_inserts = sqlBatchInsertBuilder(df, dbtable, nrecords)
  
  # begin transaction
  RODBC::odbcSetAutoCommit(db_conn, autoCommit = FALSE)
  batch_results = lapply(batch_inserts, function(insert_query) {
    # send insert statements and retrieve rows affected
    status = RODBC::sqlQuery(db_conn, insert_query)
    rowsaff = RODBC::sqlQuery(db_conn, "SELECT @@ROWCOUNT AS RC")[["RC"]]
    # return errors if any and rows affected
    if (!identical(status, character(0))) {
      list(status[!grepl("RODBC", status)], rowsaff)
    } else {
      list(NULL, rowsaff)
    }
  })

  status_list = lapply(batch_results, `[[`, 1)
  error_list = status_list[lengths(status_list) != 0]

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
    rm(list = ls(rowsaff_env), envir = rowsaff_env)
    rowsaff_env$ROWCOUNT = sum(vapply(batch_results, `[[`, 2, FUN.VALUE = integer(1)))
    # commit and set auto commit back to default
    RODBC::odbcEndTran(db_conn, commit = TRUE)
    RODBC::odbcSetAutoCommit(db_conn, autoCommit = TRUE)
    return(1)
  }
}
