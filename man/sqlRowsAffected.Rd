\name{sqlRowsAffected}
\alias{sqlRowsAffected}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
The number of rows affected on a database table after 1 is returned by \code{sqlBatchInserts()} or \code{sqlQueryTran()}.
}
\usage{
sqlRowsAffected()
}
%- maybe also 'usage' for other objects documented here.
\details{
After a statement is successfully executed by \code{sqlBatchInserts()} or \code{sqlQueryTran()}, the rows affected are stored in the enviroment, \code{rowsaff_env}.
}
\value{
Returns an integer, reflecting the number of rows affected after a SQL statement.
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

sqlQuery(db_conn, "CREATE TABLE #dftest (nums int, chars char(1));")

# 1. sqlBatchInserts()
sqlBatchInserts(db_conn, dftest, table = "#dftest", query_tmpl = "(NULLIF(?, ''), '?')", 
                cols = c("nums1", "chars2"), nrows = 5, preview = FALSE)
sqlRowsAffected()

# 2. sqlQueryTran()
sqlQueryTran(db_conn, "UPDATE #dftest SET nums = 666;", prompt = FALSE)
sqlRowsAffected()

sqlQuery(db_conn, "DROP TABLE #dftest;")
close(db_conn)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
