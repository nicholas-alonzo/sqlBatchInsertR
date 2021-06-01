sqlBatchInsert <- function(db_conn, df, dbtable, vals_tmpl, nrecords = 1000) {
  
  # retrieve parameterized "INSERT INTO" statements
  batch_inserts = sqlBatchInsertBuilder(df, dbtable, vals_tmpl, nrecords)
  
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
