sqlBatchInsert <- function(dbconn, df, dbtable, nrecords = 1000) {
  
  if (!RODBC:::odbcValidChannel(dbconn))
    stop("First argument (dbconn) is not an open RODBC channel")
  if (missing(df))
    stop("Second argument (df) is missing")
  if (!is.data.frame(df))
    stop("Second argument (df) must be a data frame")
  if (missing(dbtable))
    stop("Third argument (dbtable) is missing")
  if (!is.character(dbtable) || length(dbtable) != 1)
    stop("Third argument (dbtable) must be character(1)")
  if (RODBC::odbcQuery(dbconn, paste("SELECT 1 FROM", dbtable)) == -1L)
    stop(dbtable, " does not exist in the database")
  if (!is.numeric(nrecords) || length(nrecords) != 1 || !(nrecords %in% seq(1, 1000)))
    stop("Fourth argument (nrecords) must be numeric(1) from 1 to 1000")
  
  # retrieve parameterized "INSERT INTO" statements
  batch_inserts = sqlBatchInsertBuilder(df, dbtable, nrecords)
  
  # begin transaction
  RODBC::odbcSetAutoCommit(dbconn, autoCommit = FALSE)
  batch_results = lapply(batch_inserts, function(insert_statement) {
    # send insert statements
    status = RODBC::sqlQuery(dbconn, insert_statement)
    # return odbc errors if any
    if (!identical(status, character(0))) status[!grepl("RODBC", status)]
  })

  error_list = batch_results[lengths(batch_results) != 0]

  if (length(error_list) > 0) {
    # pass the error list to the error environment
    rm(list = ls(error_env), envir = error_env)
    list2env(error_list, error_env)
    # rollback and set auto commit back to default
    RODBC::odbcEndTran(dbconn, commit = FALSE)
    RODBC::odbcSetAutoCommit(dbconn, autoCommit = TRUE)
    return(-1)
  } else {    
    # calculate the total rows affected from batch inserts
    rm(list = ls(rowsaff_env), envir = rowsaff_env)
    rowsaff_env$ROWCOUNT = nrow(df)
    # commit and set auto commit back to default
    RODBC::odbcEndTran(dbconn, commit = TRUE)
    RODBC::odbcSetAutoCommit(dbconn, autoCommit = TRUE)
    return(1)
  }
}
