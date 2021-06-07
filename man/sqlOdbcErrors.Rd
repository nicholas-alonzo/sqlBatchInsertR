\name{sqlOdbcErrors}
\alias{sqlOdbcErrors}

\title{
A list of ODBC errors
}
\description{
\code{sqlOdbcErrors()} returns ODBC errors captured when -1 is returned by \code{sqlBatchInsert()} or \code{sqlTransaction()}.
}
\usage{
sqlOdbcErrors()
}

\details{
After a statement fails to execute by \code{sqlBatchInsert()} or \code{sqlTransaction()}, the ODBC erorrs are stored in the enviroment, \code{error_env}. 

Calling \code{sqlOdbcErrors()} will return the errors from \code{error_env} as a list and then clear the environment until \code{sqlBatchInsert()} or \code{sqlTransaction()} returns -1. **If \code{sqlOdbcErrors()} is called again sequentially, the result will be an empty list. Only one set of errors will be stored from \code{sqlBatchInsert()} or \code{sqlTransaction()}, never both.
}
\value{
Returns a list of ODBC errors or an empty list.
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
Nicholas Alonzo
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
\code{\link{sqlBatchInsert}, \link{sqlTransaction}, \link{sqlRowsAffected}}
}
\examples{
# Using a non-standard port to SQL Server 2019
driver = "Driver={ODBC Driver 17 for SQL Server};"
server = "Server=127.0.0.1,1401;"
database = "Database=testdb;"
uid = "UID=testuser;"
pwd = "PWD=testpassword;"

connection_string = paste0(driver, server, database, uid, pwd)
dbconn = RODBC::odbcDriverConnect(connection = connection_string)

dftest = data.frame(
  nums1 = c(1, 9, 8, 5, 2, NA_integer_, 1, 9, 9, 9),
  chars1 = c("a", "b", "c", "d", "e", "f", "g", "h", "i", ""),
  nums2 = c(1, 2, 3, 4, NA_integer_, 6, 7, 8, 9, NA_integer_),
  chars2 = c("m", "r", ".", NA_character_, "b", "u", "n", "g", "l", "e"),
  stringsAsFactors = FALSE)


## Example 1: Using sqlBatchInsert()
# With constraints on columns
create_table_statement = "
CREATE TABLE #dbtest (
  nums INT NOT NULL, 
  chars CHAR(1), 
  nums2 INT, 
  chars2 CHAR(1) NOT NULL
);"
RODBC::sqlQuery(channel = dbconn, query = create_table_statement)

sqlBatchInsert(dbconn, dftest, "#dbtest", nrecords = 5)
sqlOdbcErrors()
sqlRowsAffected()
RODBC::sqlQuery(channel = dbconn, query = "DROP TABLE #dbtest;")


## Example 2: Using sqlTransaction()
# Without constraints on columns
create_table_statement = "
CREATE TABLE #dbtest (
  nums INT, 
  chars CHAR(1), 
  nums2 INT, 
  chars2 CHAR(1)
);"
RODBC::sqlQuery(channel = dbconn, query = create_table_statement)

sqlBatchInsert(dbconn, dftest, "#dbtest", nrecords = 5)
sqlRowsAffected()
sqlTransaction(dbconn, "UPDATE #dbtest SET chars = 'abc' WHERE nums IS NULL;")
sqlOdbcErrors()
sqlRowsAffected()
RODBC::sqlQuery(channel = dbconn, query = "DROP TABLE #dbtest;")


RODBC::odbcClose(channel = dbconn)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
