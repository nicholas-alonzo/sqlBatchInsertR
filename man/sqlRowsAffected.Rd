\name{sqlRowsAffected}
\alias{sqlBatchInsertR}

\title{
The number of rows affected
}
\description{
The number of rows affected in a database table after 1 is returned by \code{sqlBatchInserts()} or \code{sqlTransaction()}.
}
\usage{
sqlRowsAffected()
}

\details{
After a statement is successfully executed by \code{sqlBatchInserts()} or \code{sqlTransaction()}, the rows affected are stored in the enviroment, \code{rowsaff_env}.

Calling \code{sqlRowsAffected()} will return the number of rows affected and then clear the environment until \code{sqlBatchInserts()} or \code{sqlTransaction()} returns 1. **If \code{sqlRowsAffected()} is called again sequentially, the result will be NULL.
}
\value{
Returns an integer, reflecting the number of rows affected from a SQL statement or NULL. 
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
\code{\link{sqlBatchInserts}, \link{sqlTransaction}}
}
\examples{
# Using a non-standard port to SQL Server 2019
driver = "Driver={ODBC Driver 17 for SQL Server};"
server = "Server=127.0.0.1,1401;"
database = "Database=testdb;"
uid = "UID=testuser;"
pwd = "PWD=testpassword;"

connection_string = paste0(driver, server, database, uid, pwd)
db_conn = RODBC::odbcDriverConnect(connection = connection_string)

dftest = data.frame(
  nums1 = c(1, 9, 8, 5, 2, NA_integer_, 1, 9, 9, 9),
  chars1 = c("a", "b", "c", "d", "e", "f", "g", "h", "i", ""),
  nums2 = c(1, 2, 3, 4, NA_integer_, 6, 7, 8, 9, NA_integer_),
  chars2 = c("m", "r", ".", NA_character_, "b", "u", "n", "g", "l", "e"),
  stringsAsFactors = FALSE)

# number of placeholders match number of columns in data frame 
# placeholders are wrapped in single quotes for character column positions
values_template = "(?, '?', ?, '?')"


# Test 1 - Using sqlBatchInserts()
create_table_statement = "
CREATE TABLE #dbtest (
  nums INT, 
  chars CHAR(1), 
  nums2 INT, 
  chars2 CHAR(1)
);"
RODBC::sqlQuery(channel = db_conn, query = create_table_statement)

sqlBatchInserts(db_conn, dftest, "#dbtest", values_template, nrecords = 5)
sqlRowsAffected()


# Test 2 - Using sqlTransaction()
sqlTransaction(db_conn, "UPDATE #dbtest SET nums = 666;", prompt = FALSE)
sqlRowsAffected()
RODBC::sqlQuery(channel = db_conn, query = "DROP TABLE #dbtest;")


RODBC::odbcClose(channel = db_conn)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
