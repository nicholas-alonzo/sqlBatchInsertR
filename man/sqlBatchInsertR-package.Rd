\name{sqlBatchInsertR-package}
\alias{sqlBatchInsertR}
\docType{package}
\title{
sqlBatchInsertR
}
\description{
\strong{sqlBatchInsertR} aims to extend the functionality of the \strong{RODBC} package by providing a simple and effective way of inserting data into a database table.
}
\details{
There are 2 main wrapper functions, \code{sqlBatchInsert()} and \code{sqlTransaction()}.

\code{sqlBatchInsert()} inserts values from a data frame into a database table in a transaction using a list of parameterized \code{INSERT INTO} statements.

\code{sqlTransaction()} prompts the user to commit or rollback the results of a SQL \code{INSERT}, \code{UPDATE}, or \code{DELETE} statement.

There are also 2 helper functions, \code{sqlRowsAffected()} and \code{sqlOdbcErrors()}.

\code{sqlRowsAffected()} returns the number of rows affected in a database table after a statement is successfully executed by \code{sqlBatchInsert()} or \code{sqlTransaction()}.

\code{sqlOdbcErrors()} returns ODBC errors after a statement fails to execute by \code{sqlBatchInsert()} or \code{sqlTransaction()}.
}
\author{
Nicholas Alonzo
}

\keyword{ package }
\seealso{

\code{\link{sqlBatchInsert}, \link{sqlTransaction}, \link{sqlRowsAffected}, \link{sqlOdbcErrors}, \link[RODBC:sqlQuery]{sqlQuery}}

}
\examples{
sqlBatchInsert(dbconn, df, dbtable, nrecords = 1000)

sqlTransaction(db_conn, statement, prompt = TRUE, addl_text = NULL)

sqlRowsAffected()

sqlOdbcErrors()
}
