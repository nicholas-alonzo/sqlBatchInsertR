\name{sqlRowsAffected}
\alias{sqlRowsAffected}

\title{
Return the number of rows affected
}
\description{
The number of rows affected in a database table after \code{sqlBatchInsert()} or \code{sqlTransaction()} are successfully executed.
}
\usage{
sqlRowsAffected()
}

\details{
After \code{sqlBatchInsert()} or \code{sqlTransaction()} are successfully executed, the rows affected are stored in the enviroment, \code{rowsaff_env}.

Calling \code{sqlRowsAffected()} will return the number of rows affected and then clear the environment. **If \code{sqlRowsAffected()} is called again sequentially, the result will be NULL.
}
\value{
Returns a number reflecting the number of rows affected or NULL. 
}
\references{
\href{https://github.com/nicholas-alonzo/sqlBatchInsertR/wiki}{sqlBatchInsertR Wiki}
}
\author{
Nicholas Alonzo
}

\seealso{
\code{\link{sqlBatchInsert}, \link{sqlTransaction}, \link{sqlOdbcErrors}, \link[RODBC:sqlQuery]{sqlQuery}}
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

create_table_statement = "
CREATE TABLE #dbtest (
  nums INT, 
  chars CHAR(1), 
  nums2 INT, 
  chars2 CHAR(1)
);"
RODBC::sqlQuery(channel = dbconn, query = create_table_statement)


# Example 1: Using sqlBatchInsert()
sqlBatchInsert(dbconn, dftest, "#dbtest")
sqlRowsAffected()


# Example 2: Using sqlTransaction()
sqlTransaction(dbconn, "UPDATE #dbtest SET nums = 666;", prompt = FALSE)
sqlRowsAffected()


RODBC::sqlQuery(channel = dbconn, query = "DROP TABLE #dbtest;")
RODBC::odbcClose(channel = dbconn)
}
}