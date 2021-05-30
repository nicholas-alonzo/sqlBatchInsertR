\name{sqlQueryTran}
\alias{sqlQueryTran}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
Execute a SQL command through a transaction and be prompted to commit or rollback the results.
}
\usage{
sqlQueryTran(db_conn, query, prompt = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{db_conn}{
(RODBC)
  
The connected database connection handle returned by RODBC's \code{odbcConnect()} or \code{odbcDriverConnect()} to be used for inserting data into the database table.
}
  \item{query}{
(character(1))

The SQL command, primarily \code{UPDATE}, \code{INSERT}, or \code{DELETE} statements.
}
  \item{prompt}{
(logical(1) | default = TRUE)

If \code{prompt = TRUE}, the number of rows affected is displayed and a prompt for committing the transaction is asked. If \code{prompt = FALSE} the transaction is commited without knowing the number of rows affected until \code{sqlRowsAffected()} is called.
}
  \item{addl_text}{
(character(1) | default = NULL)

Additional text to add in front of the user prompt.
}
}
\details{
Before \code{prompt} is evaluated and displayed, if the statement returns an error or has no affect on rows, -1 or 0 is returned respectively.
}
\value{
Returns -1 on failure, 0 when no records are affected, 1 on success.
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
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
driver = "driver={SQL Server};"
server = "server=testserver;"
database = "database=testdb;"
authentication = "trusted_connection=true;"

connection_string = paste0(driver, server, database, authentication)

db_conn = odbcDriverConnect(connection_string)

dftest = data.frame(nums1 = c(1, 9, 8, 5, 2, NA_integer_, 1, 9, 9, 9),
                    chars1 = c("a", "b", "c", "d", "e", "f", "g", "h", "i", ""),
                    nums2 = c(1, 2, 3, 4, NA_integer_, 6, 7, 8, 9, NA_integer_),
                    chars2 = c("m", "r", ".", NA_character_, "b", "u", "n", "g", "l", "e"),
                    stringsAsFactors = FALSE)

# refer to sqlBatchInserts() example
sqlQuery(db_conn, "CREATE TABLE #dftest (nums int, chars char(1));")
sqlBatchInserts(db_conn, dftest, table = "#dftest", query_tmpl = "(NULLIF(?, ''), '?')", 
                cols = c("nums1", "chars2"), nrows = 5, preview = FALSE)

## Example 1: Commit after prompt
update_query = "UPDATE #dftest SET chars = '.' WHERE nums = 5;"
sqlQueryTran(db_conn, update_query, prompt = TRUE, addl_text = "Updating chars field -")
# Updating chars field - 1 row(s) affected, commit? (y/n): y
sqlQuery(db_conn, "SELECT * FROM #dftest;")

## Example 2: Rollback after prompt
update_query = "UPDATE #dftest SET nums = 6 WHERE chars IN ('m', 'r', 'b');"
sqlQueryTran(db_conn, update_query, prompt = TRUE)
# 3 row(s) affected, commit? (y/n): n
sqlQuery(db_conn, "SELECT * FROM #dftest;")

## Example 3: Commit with no prompt
update_query = "UPDATE #dftest SET nums = 666;"
sqlQueryTran(db_conn, update_query, prompt = FALSE)
sqlRowsAffected()
sqlQuery(db_conn, "SELECT * FROM #dftest;")

sqlQuery(db_conn, "DROP TABLE #dftest;")
close(db_conn)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
