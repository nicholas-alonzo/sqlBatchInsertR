\name{sqlBatchInsertR-package}
\alias{sqlBatchInsertR}
\docType{package}
\title{
sqlBatchInsertR
}
\description{
sqlBatchInsertR aims to extend the functionality of the RODBC package by providing a simple and efficient way of inserting a data frame into a database table.
}
\details{
The main function of this package is \code{sqlBatchInsert()}. It inserts a data frame into a database table in a transaction using a list of parameterized \code{INSERT} statements.

There are 3 additional functions, \code{sqlTransaction()}, \code{sqlRowsAffected()} and \code{sqlOdbcErrors()}.

\code{sqlTransaction()} prompts the user to commit or rollback the results of a SQL \code{INSERT}, \code{UPDATE}, or \code{DELETE} statement.

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

sqlTransaction(dbconn, statement, prompt = TRUE, addl_text = NULL)

sqlRowsAffected()

sqlOdbcErrors()
}
