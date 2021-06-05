sqlTransaction <- function(db_conn, statement, prompt = TRUE, addl_text = NULL) {
  
  if (!RODBC:::odbcValidChannel(db_conn))
    stop("First argument (db_conn) is not an open RODBC channel")
  if (missing(statement))
    stop("Second argument (statement) is missing")
  if (!grepl("INSERT|UPDATE|DELETE", statement, ignore.case = TRUE))
    stop("Second argument (statement) must be a INSERT, UPDATE, or DELETE statment")
  if (!is.logical(prompt) || length(prompt) != 1)
    stop("Third argument (prompt) must be logical(1)")
  if (!is.null(addl_text) && (!is.character(addl_text) || length(addl_text) != 1))
    stop ("Fourth argument (addl_text) must be NULL or character(1)")
  
  # set up error list and begin transaction
  error_list = list()
  RODBC::odbcSetAutoCommit(db_conn, autoCommit = FALSE)
  
  status = RODBC::odbcQuery(db_conn, statement)
  
  if (status == -1) {
    # retrieve errors
    errors = RODBC::odbcGetErrMsg(db_conn)
    # error reason: odbc errors, no reason to prompt
    if (any(!grepl("RODBC", errors))) {
      error_list[["Errors"]] = errors[!grepl("RODBC", errors)]
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
    ROWCOUNT = RODBC::sqlQuery(db_conn, "SELECT @@ROWCOUNT AS RC")[["RC"]]
    
    if (prompt == FALSE) {
      # commit and set auto commit back to default
      RODBC::odbcEndTran(db_conn, commit = TRUE)
      RODBC::odbcSetAutoCommit(db_conn, autoCommit = TRUE)
      return(1)
    } else if (prompt == TRUE) {
      # retrieve user input
      repeat {
        if (is.null(addl_text)) {
          prompt_user = paste(ROWCOUNT, "row(s) affected, commit? (y/n): ")
        } else {
          prompt_user = paste(addl_text, ROWCOUNT, "row(s) affected, commit? (y/n): ")
        }
        response = readline(prompt_user)
        if (response %in% c("y", "n")) break
      }    
      
      if (response == "y") {
        # commit and set auto commit back to default
        RODBC::odbcEndTran(db_conn, commit = TRUE)
        RODBC::odbcSetAutoCommit(db_conn, autoCommit = TRUE)
        # populate the environment with rows affected
        rm(list = ls(rowsaff_env), envir = rowsaff_env)
        rowsaff_env$ROWCOUNT = ROWCOUNT
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