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
There are 2 main wrapper functions, \code{sqlBatchInsert()} and \code{sqlTransaction()}.

\code{sqlBatchInsert()} inserts values from a data frame into a database table in a transaction using a list of parameterized \code{INSERT INTO} statements. The parameterized statements are built using \code{sprintf()} and \code{paste0()}. **It is important to note that this can be prone to SQL injections. Be sure the data comes from a trusted source.

\code{sqlTransaction()} prompts the user to commit or rollback the results of a SQL statement in a transaction. It is most useful with \code{UPDATE}, \code{INSERT}, or \code{DELETE} commands.

In addition, two 
}
\author{
Nicholas Alonzo
}

\keyword{ package }
\seealso{

\code{\link{sqlBatchInsert}, \link{sqlTransaction}, \link{sqlRowsAffected}}, \code{\link{sqlErrors}, \link[RODBC:sqlQuery]{sqlQuery}}

}
\examples{
sqlBatchInsert(db_conn, df, dbtable, vals_tmpl, nrecords = 1000)

sqlTransaction(db_conn, statement, prompt = TRUE, addl_text = NULL)

sqlRowsAffected()

sqlErrors()
}
