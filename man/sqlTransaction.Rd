\name{sqlTransaction}
\alias{sqlTransaction}

\title{
Be prompted to commit a SQL DML statement
}
\description{
Be prompted by \code{sqlTransaction()} to commit or rollback the results of a SQL \code{INSERT}, \code{UPDATE}, or \code{DELETE} statement.
}
\usage{
sqlTransaction(dbconn, statement, prompt = TRUE, addl_text = NULL)
}

\arguments{
  \item{dbconn}{
(RODBC)
  
A open database connection handle returned by RODBC's \code{odbcConnect()} or \code{odbcDriverConnect()}.
}
  \item{statement}{
(character(1))

The SQL \code{UPDATE}, \code{INSERT}, or \code{DELETE} statement.
}
  \item{prompt}{
(logical(1) | default = TRUE)

If \code{prompt = TRUE}, the number of rows affected is displayed and a prompt for committing the transaction is asked. 

If \code{prompt = FALSE} the transaction is commited without knowing the number of rows affected until \code{sqlRowsAffected()} is called.
}
  \item{addl_text}{
(character(1) | default = NULL)

Additional text to add in front of the prompt.
}
}
\details{
Only a SQL \code{UPDATE}, \code{INSERT}, or \code{DELETE} statement can be executed with \code{sqlTransaction()}, otherwise an error is returned.

Before \code{prompt} is evaluated, if the statement returns an error or has no affect on rows, -1 or 0 is returned respectively. When prompt is TRUE and the statement is valid, 
}
\value{
Returns -1 on failure, 0 when no records are affected, and 1 on success.
}
\references{
\href{https://github.com/nicholas-alonzo/sqlBatchInsertR/wiki}{sqlBatchInsertR Wiki}
}
\author{
Nicholas Alonzo
}
\seealso{
\code{\link{sqlBatchInsert}, \link{sqlRowsAffected}, \link{sqlOdbcErrors}, \link[RODBC:sqlQuery]{sqlQuery}, \link[RODBC:odbcSetAutoCommit]{odbcSetAutoCommit}, \link[RODBC:odbcEndTran]{odbcEndTran}}
}
\examples{
\dontrun{
dbconn = RODBC::odbcDriverConnect(connection = "connection_string"")

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
sqlBatchInsert(dbconn, dftest, "#dbtest")


# Example 1: Commit after prompt
update_statement = "UPDATE #dbtest SET chars = '.' WHERE nums = 5;"
sqlTransaction(dbconn, update_statement, addl_text = "Update chars field - ")
# Update chars field - 1 row(s) affected, commit? (y/n): y
sqlRowsAffected()
RODBC::sqlQuery(channel = dbconn, query = "SELECT * FROM #dbtest;")


# Example 2: Rollback after prompt
update_statement = "UPDATE #dbtest SET nums = 6 WHERE chars IN ('m', 'b');"
sqlTransaction(dbconn, update_statement)
# 2 row(s) affected, commit? (y/n): n
sqlRowsAffected()
RODBC::sqlQuery(channel = dbconn, query = "SELECT * FROM #dbtest;")


# Example 3: Commit with no prompt
update_statement = "UPDATE #dbtest SET nums = 666;"
sqlTransaction(dbconn, update_statement, prompt = FALSE)
sqlRowsAffected()
RODBC::sqlQuery(channel = dbconn, query = "SELECT * FROM #dbtest;")


RODBC::sqlQuery(channel = dbconn, query = "DROP TABLE #dbtest;")
RODBC::odbcClose(channel = dbconn)
}
}