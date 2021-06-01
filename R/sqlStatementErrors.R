sqlStatementErrors <- function() {
  
  odbc_errors = as.list.environment(error_env, sorted = TRUE)
  rm(list = ls(error_env), envir = error_env)
  return(odbc_errors)
}