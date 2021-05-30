sqlQueryTran <- function(db_conn, query, prompt = TRUE, addl_text = NULL) {
  
  # set up error list and begin transaction
  error_list = list()
  RODBC::odbcSetAutoCommit(db_conn, autoCommit = FALSE)
  
  status = RODBC::odbcQuery(db_conn, query)
  
  if (status == -1) {
    # retrieve errors
    errors = RODBC::odbcGetErrMsg(db_conn)
    
    # error reason: MSSQL DB errors, no reason to prompt
    if (any(grepl("Microsoft", errors))) {
      odbc_errors = errors[grepl("Microsoft", errors)]
      error_list[["Errors"]] = odbc_errors
      # pass the errors to the error environment
      rm(list = ls(error_env), envir = error_env)
      list2env(error_list, error_env)
      # rollback and set auto commit back to default
      RODBC::odbcEndTran(db_conn, commit = FALSE)
      RODBC::odbcSetAutoCommit(db_conn, autoCommit = TRUE)
      return(-1)
    } else {
      # error reason: no data affected, no reason to prompt
      RODBC::odbcEndTran(db_conn, commit = FALSE)
      RODBC::odbcSetAutoCommit(db_conn, autoCommit = TRUE)
      return(0)
    }
  } else {
    # populate the environment with rows affected
    ROWCOUNT = RODBC::sqlQuery(db_conn, "SELECT @@ROWCOUNT AS RC")[["RC"]]
    rowsaff_env$ROWCOUNT = ROWCOUNT
    
    if (prompt == FALSE) {
      # commit and set auto commit back to default
      RODBC::odbcEndTran(db_conn, commit = TRUE)
      RODBC::odbcSetAutoCommit(db_conn, autoCommit = TRUE)
      return(1)
    } else if (prompt == TRUE) {
      
      repeat {
        
        # retrieve user input
        if (is.null(addl_text)) {
          prompt_user = paste(ROWCOUNT, "row(s) affected, commit? (y/n): ")
        } else {
          prompt_user = paste(addl_text, ROWCOUNT, "row(s) affected, commit? (y/n): ")
        }
        response = readline(prompt_user)
        if (response %in% c("y", "n")) {
          break
        }
      }    
      
      if (response == "y") {
        # commit and set auto commit back to default
        RODBC::odbcEndTran(db_conn, commit = TRUE)
        RODBC::odbcSetAutoCommit(db_conn, autoCommit = TRUE)
        return(1)
      } else {
        # rollback and set auto commit back to default
        RODBC::odbcEndTran(db_conn, commit = FALSE)
        RODBC::odbcSetAutoCommit(db_conn, autoCommit = TRUE)
        return(0)
      }
    }
  }
}