sqlRowsAffected <- function() {
  
  rows_affected = tryCatch({
    rows = get("ROWCOUNT", envir = rowsaff_env)
    rm(list = ls(rowsaff_env), envir = rowsaff_env)
    return(rows)
  },
  error = function(cond) return(NULL)
  )
  return(rows_affected)
}