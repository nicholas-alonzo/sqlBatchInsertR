\name{sqlBatchInsertR-package}
\alias{sqlBatchInsertR}
\docType{package}
\title{
sqlBatchInsertR
}
\description{
sqlBatchInsertR aims to extend the functionality of the \link[RODBC:RODBC]{RODBC} package by providing an efficient way of inserting a data frame into a database table and handling SQL DML statements.
}
\details{
Below are the main functions of the package.

\code{sqlBatchInsert()} inserts a data frame into a database table in a transaction using a list of parameterized \code{INSERT} statements.

\code{sqlTransaction()} prompts the user to commit or rollback the results of a SQL \code{INSERT}, \code{UPDATE}, or \code{DELETE} statement.

\code{sqlRowsAffected()} returns the number of rows affected in a database table when \code{sqlBatchInsert()} or \code{sqlTransaction()} are successfully executed.

\code{sqlOdbcErrors()} returns a list of ODBC errors after \code{sqlBatchInsert()} or \code{sqlTransaction()} fails to execute.
}
\references{
\href{https://github.com/nicholas-alonzo/sqlBatchInsertR/wiki}{sqlBatchInsertR Wiki}
}
\author{
Nicholas Alonzo
}

\keyword{ package }
\seealso{

\code{\link{sqlBatchInsert}, \link{sqlTransaction}, \link{sqlRowsAffected}, \link{sqlOdbcErrors}, \link[RODBC:odbcConnect]{odbcConnect}, \link[RODBC:odbcDriverConnect]{odbcDriverConnect}, \link[RODBC:sqlQuery]{sqlQuery}, \link[RODBC:odbcSetAutoCommit]{odbcSetAutoCommit}, \link[RODBC:odbcEndTran]{odbcEndTran}}

}
\examples{
sqlBatchInsert(dbconn, df, dbtable, nrecords = 1000)

sqlTransaction(dbconn, statement, prompt = TRUE, addl_text = NULL)

sqlRowsAffected()

sqlOdbcErrors()
}
