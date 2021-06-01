\name{sqlBatchInserts}
\alias{sqlBatchInsertR}

\title{
Insert a data frame into a database table in batches
}
\description{
\code{sqlBatchInserts()} inserts values of a data frame into a database table in one transaction using a list of parameterized \code{INSERT INTO} statements.

\code{sqlBatchInsertsBuilder()} converts a data frame to parameterized \code{INSERT INTO} statements for \code{sqlBatchInserts()}.
}
\usage{
sqlBatchInserts(db_conn, df, dbtable, vals_tmpl, nrecords = 1000)

sqlBatchInsertsBuilder(df, dbtable, vals_tmpl, nrecords = 1000)
}

\arguments{
  \item{db_conn}{
(RODBC)

A open database connection handle returned by RODBC's \code{odbcConnect()} or \code{odbcDriverConnect()} to be used for inserting data into a database table.
}
  \item{df}{
(data frame)

A data frame containing values to be inserted into a database table through a open database connection. **Ideally, the data frame should be preprocessed and contain only character or numeric columns.
}
  \item{dbtable}{
(character(1))

The database table name accessible from a open database connection.
}
  \item{vals_tmpl}{
(character(1))

The template for the values to be parameterized on using "?" as the placeholder. If the value is a string data type then wrap the placeholder in single quotes. If the value is a numeric data type then leave the placeholder as is. The number of placeholders must match the number of columns in the dataframe otherwise an error is returned.
}
  \item{nrecords}{
(integer(1) | default = 1000)

The number of records to be inserted per batch. As stated in \href{https://technet.microsoft.com/en-us/library/ms187905(v=sql.105).aspx}{Microsoft's SQL Server documentation}, "the maximum number of rows that can be inserted in a single \code{INSERT} statement is 1000." Depending on the size (bytes) of the values per row being inserted, adjusting the number of rows may speed up insertion into the database table.
}
}
\details{
A list of parameterized \code{INSERT INTO} statements are executed in batches in one transaction. In the process of building the statements, NA values in character columns are updated to an empty string. Non-character columns (ideally numeric) are coerced to character and NA values are changed to NULL. If any of the batches fail, the transaction is rolled back. Errors that occured in any batches can be viewed using \code{sqlStatementErrors()}.

The values being inserted will follow the order of the data frame columns and should reflect the order of the database table columns respectively. **The names of the columns in the data frame do not have to match the names of the columns in the database table.
}
\value{
\code{sqlBatchInserts()} returns 1 on success and -1 on failure.

\code{sqlBatchInsertsBuilder()} returns a list of parameterized \code{INSERT INTO} statements.
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
\code{\link{sqlTransaction}, \link{sqlRowsAffected}}, \code{\link{sqlStatementErrors}}
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


# Test 1 - Without constraints on columns
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
RODBC::sqlQuery(channel = db_conn, query = "SELECT * FROM #dbtest;")
RODBC::sqlQuery(channel = db_conn, query = "DROP TABLE #dbtest;")


# Test 2 - With constraint on columns
create_table_statement = "
CREATE TABLE #dbtest (
  nums INT NOT NULL, 
  chars CHAR(1), 
  nums2 INT, 
  chars2 CHAR(1) NOT NULL
);"
RODBC::sqlQuery(channel = db_conn, query = create_table_statement)

sqlBatchInserts(db_conn, dftest, "#dbtest", values_template, nrecords = 5)
sqlStatementErrors()
sqlRowsAffected()
RODBC::sqlQuery(channel = db_conn, query = "SELECT * FROM #dbtest;")
RODBC::sqlQuery(channel = db_conn, query = "DROP TABLE #dbtest;")


RODBC::odbcClose(channel = db_conn)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
