\name{sqlBatchInsert}
\alias{sqlBatchInsert}
\alias{sqlBatchInsertBuilder}

\title{
Insert a data frame into a database table
}
\description{
\code{sqlBatchInsert()} inserts a data frame into a database table in one transaction using a list of parameterized \code{INSERT} statements.

\code{sqlBatchInsertBuilder()} converts a data frame to a list of parameterized \code{INSERT} statements for \code{sqlBatchInsert()}.
}
\usage{
sqlBatchInsert(dbconn, df, dbtable, nrecords = 1000)

sqlBatchInsertBuilder(df, dbtable, nrecords = 1000)
}

\arguments{
  \item{dbconn}{
(RODBC)

A open database connection handle returned by RODBC's \code{odbcConnect()} or \code{odbcDriverConnect()}.
}
  \item{df}{
(data frame)

A data frame to be inserted into a database table through a open database connection.
}
  \item{dbtable}{
(character(1))

The database table name accessible from the open database connection.
}
  \item{nrecords}{
(integer(1) | default = 1000)

The number of records to be inserted per batch. 

As stated in \href{https://technet.microsoft.com/en-us/library/ms187905(v=sql.105).aspx}{Microsoft's SQL Server documentation}, "the maximum number of rows that can be inserted in a single \code{INSERT} statement is 1000." Depending on the size (bytes) of the values per row being inserted, adjusting the number of rows may speed up insertion into the database table.
}
}
\details{
A list of parameterized \code{INSERT INTO} statements are executed in batches in one transaction. The number of batches are determined by the number of rows in the data frame and \code{nrecords}.

In the process of building the statements, values are mapped as \strong{numeric} or \strong{string} using data frame column classes. The classes \code{integer}, \code{logical}, and \code{numeric} are interpreted as \strong{numeric}, while all other classes like \code{character}, \code{factor}, \code{Date}, \code{POSIXct}, and \code{POSIXlt} are interpreted as \strong{string}. \strong{String} values are quoted to string literals to prevent SQL injections. \code{NA} values are updated to "NULL" characters across the data frame. 

If any of the batches fail, the transaction is rolled back. Errors that occured in any batches can be viewed using \code{sqlOdbcErrors()}.

**The values being inserted will follow the order of the data frame columns and should reflect the order of the database table columns respectively. The names of the columns in the data frame do not have to match the names of the columns in the database table.
}
\value{
\code{sqlBatchInsert()} returns 1 on success and -1 on failure.

\code{sqlBatchInsertBuilder()} returns a list of parameterized \code{INSERT INTO} statements.
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
Nicholas Alonzo
}
\note{
Inserting data into a temporary table has been the best use for the function. It mimics the data frame and allows users to write direct SQL commands that can be processed by the DBMS itself.
}

\seealso{
\code{\link{sqlTransaction}, \link{sqlRowsAffected}, \link{sqlOdbcErrors}}
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


## Example 1: Without constraints on columns
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
RODBC::sqlQuery(channel = dbconn, query = "SELECT * FROM #dbtest;")
RODBC::sqlQuery(channel = dbconn, query = "DROP TABLE #dbtest;")


## Example 2: With constraint on columns
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
RODBC::sqlQuery(channel = dbconn, query = "SELECT * FROM #dbtest;")
RODBC::sqlQuery(channel = dbconn, query = "DROP TABLE #dbtest;")


RODBC::odbcClose(channel = dbconn)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
