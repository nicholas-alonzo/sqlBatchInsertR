\name{sqlStatementErrors}
\alias{sqlStatementErrors}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
MSSQL DB errors captured when -1 is returned by \code{sqlBatchInserts()} or \code{sqlQueryTran()}.
}
\usage{
sqlStatementErrors()
}
%- maybe also 'usage' for other objects documented here.
\details{
After a statement fails to execute by \code{sqlBatchInserts()} or \code{sqlQueryTran()}, the erorrs are stored in the enviroment, \code{error_env}.
}
\value{
For \code{sqlBatchInserts()}:\cr
\code{$`Batch 1 Failed` \cr [1] ... [Microsoft][ODBC SQL Server Driver][SQL Server] ...} 
  
For \code{sqlQueryTran()}:\cr
\code{$Errors \cr [1] ... [Microsoft][ODBC SQL Server Driver][SQL Server] ...}
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

sqlQuery(db_conn, "CREATE TABLE #dftest (nums int not null, chars char(1));")

# 1. sqlBatchInserts()
sqlBatchInserts(db_conn, dftest, table = "#dftest", query_tmpl = "(NULLIF(?, ''), '?')", 
                cols = c("nums2", "chars1"), nrows = 2, preview = FALSE)
sqlStatementErrors()

# 2. sqlQueryTran()
sqlBatchInserts(db_conn, dftest, table = "#dftest", query_tmpl = "(?, '?')", 
                cols = c("nums2", "chars1"), nrows = 2, preview = FALSE)
sqlQueryTran(db_conn, "UPDATE #dftest SET nums = NULL WHERE nums = 0;", prompt = TRUE)
sqlStatementErrors()

sqlQuery(db_conn, "DROP TABLE #dftest;")
close(db_conn)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
