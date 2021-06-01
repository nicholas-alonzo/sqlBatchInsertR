\name{sqlBatchInsertR-package}
\alias{sqlBatchInsertR}
\docType{package}
\title{
sqlBatchInsertR
}
\description{
\strong{sqlBatchInsertR} is an extension to the \strong{RODBC} function \code{sqlQuery()}.
}
\details{
There are 2 main wrapper functions, \code{sqlBatchInserts()} and \code{sqlTransaction()}.

\code{sqlBatchInserts()} inserts values from a data frame into a database table through one transaction using a list of parameterized \code{INSERT INTO} statements. The parameterized statements are built using \code{sprintf()} and \code{paste()} so it is important to note that this can be prone to SQL injections. Be sure the data comes from a trusted source.


\code{sqlTransaction()} prompts the user to commit or rollback the results of a SQL command through a transaction. It is most useful with \code{UPDATE}, \code{INSERT}, or \code{DELETE} statements.
}
\author{
Nicholas Alonzo
}

\keyword{ package }
\seealso{

\code{\link[RODBC:sqlQuery]{sqlQuery}}

}
\examples{
sqlBatchInserts(dbConnection, dataframe, "dbTable", vals_tmpl = "(?, '?')", 
                cols = c("num", "char"), nrows = 5)

sqlTransaction(dbConnection, "UPDATE dbTable SET charCol = 'a' WHERE intCol = 1;")
}
