\name{sqlOdbcErrors}
\alias{sqlOdbcErrors}

\title{
Return a list of ODBC errors
}
\description{
\code{sqlOdbcErrors()} returns a list of ODBC errors when \code{sqlBatchInsert()} or \code{sqlTransaction()} fails to execute.
}
\usage{
sqlOdbcErrors()
}

\details{
After \code{sqlBatchInsert()} or \code{sqlTransaction()} fails to execute, the ODBC erorrs are stored in the enviroment, \code{error_env}. 

Calling \code{sqlOdbcErrors()} will return the errors from \code{error_env} as a list and then clear the environment. **If \code{sqlOdbcErrors()} is called again sequentially, the result will be an empty list. Only one set of errors will be stored from \code{sqlBatchInsert()} or \code{sqlTransaction()}, never both.
}
\value{
Returns a list of ODBC errors or an empty list.
}
\references{
\href{https://github.com/nicholas-alonzo/sqlBatchInsertR/wiki}{sqlBatchInsertR Wiki}
}
\author{
Nicholas Alonzo
}
\note{
\code{error_env} is an internal variable not exported from the NAMESPACE.
}
\seealso{
\code{\link{sqlBatchInsert}, \link{sqlTransaction}, \link{sqlRowsAffected}, \link[RODBC:sqlQuery]{sqlQuery}}
}
\examples{
\dontrun{
dbconn = RODBC::odbcDriverConnect(connection = "connection_string")

dftest = data.frame(
  nums1 = c(1, 9, 8, 5, 2, NA_integer_, 1, 9, 9, 9),
  chars1 = c("a", "b", "c", "d", "e", "f", "g", "h", "i", ""),
  nums2 = c(1, 2, 3, 4, NA_integer_, 6, 7, 8, 9, NA_integer_),
  chars2 = c("m", "r", ".", NA_character_, "b", "u", "n", "g", "l", "e"),
  stringsAsFactors = FALSE)


# Example 1: Using sqlBatchInsert() with constraints on columns
create_table_statement = "
CREATE TABLE #dbtest (
  nums INT NOT NULL, 
  chars CHAR(1), 
  nums2 INT, 
  chars2 CHAR(1) NOT NULL
);"
RODBC::sqlQuery(channel = dbconn, query = create_table_statement)
sqlBatchInsert(dbconn, dftest, "#dbtest")
sqlOdbcErrors()
RODBC::sqlQuery(channel = dbconn, query = "DROP TABLE #dbtest;")


# Example 2: Using sqlTransaction() without constraints on columns
create_table_statement = "
CREATE TABLE #dbtest (
  nums INT, 
  chars CHAR(1), 
  nums2 INT, 
  chars2 CHAR(1)
);"
RODBC::sqlQuery(channel = dbconn, query = create_table_statement)
sqlBatchInsert(dbconn, dftest, "#dbtest")
sqlTransaction(dbconn, "UPDATE #dbtest SET chars = 'abc' WHERE nums IS NULL;")
sqlOdbcErrors()
RODBC::sqlQuery(channel = dbconn, query = "DROP TABLE #dbtest;")


RODBC::odbcClose(channel = dbconn)
}}
