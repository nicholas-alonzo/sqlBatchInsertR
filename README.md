# sqlBatchInsertR

sqlBatchInsertR is built on top of the RODBC package and aims to extend its functionality. It provides an efficient way of inserting a data frame into a database table and handling SQL DML statements. 

__This has currently been tested for use with Microsoft SQL Server.__

## Inspiration and Motivation

In the summer of 2016 I volunteered at a non-profit community health clinic not knowing it would eventually be the start to a full-time career. My first big project was to compare Excel records to records in a MS SQL Server database.

To accomplish the task, I used R and the RODBC package. Once handled, the next phase was to keep track of the Excel records in more detail. This involved data modeling and designing an ETL process. One of the challenges I came across was the increasing amount of data in the Excel files. The RODBC package offers ```sqlSave()``` for writing to database tables, but it couldn't keep up with the demand. I wasn't the only one that noticed; there were others raising this issue on Stack Overflow, but no coded solution provided.

This is when I had the inspiration to write my own functions that could load data more efficiently into a database table. I started writing code in 2017 until I reached the solution of creating batches of parameterized INSERT statements. It was a *__major__* speed up and I became reliant on it for other projects. The code lived in a few scripts until I decided to build it out as an internal package in 2018.

It's now 2021 and I've decided to open source the package in hopes it'll be useful to others. What's nice about it is that it's minimal. Only base R is used for data manipulation and RODBC for database connectivity. I'm certain there's more enhancements that can be made, so feel free to start a discussion [here](https://github.com/nicholas-alonzo/sqlBatchInsertR/discussions/categories/enhancements). 

## Prerequisites

- [R](https://cloud.r-project.org/) (>= 4.0.0)
- [RODBC](https://cran.r-project.org/web/packages/RODBC/) (>= 1.3.0)

## Installation

### In Release: Source Package

1. Download the source package (tar.gz) of the current release [here](https://github.com/nicholas-alonzo/sqlBatchInsertR/releases).

2. In R, copy the following code into the console. 

	```r
	install.packages("sqlBatchInsertR_#.#.#.tar.gz", repos = NULL, type = "source", dependencies = TRUE)
	```
3. Change the first argument to be the path of the downloaded (tar.gz) file and press __Enter__.

### In Development (Option 1): `devtools` 

The R package `devtools` allows users to install packages from GitHub. In R, copy the following code into the console and press __Enter__.

```r
# install devtools if necessary
install.packages("devtools")

# install sqlBatchInsertR and dependent package from the GitHub repository
devtools::install_github("nicholas-alonzo/sqlBatchInsertR", dependencies = TRUE)
```

### In Development (Option 2): Command Line

1. Install [Git](http://git-scm.com/downloads) if necessary.

2. Open a terminal.

3. Change the current working directory to the location where you want the cloned directory.

4. Copy the following command into terminal and press __Enter__. This will make a full copy of the repository data that GitHub has at that point in time, including all versions of every file and folder for the project.
 
	```
	git clone https://github.com/nicholas-alonzo/sqlBatchInsertR
	```

5. Copy the following command into terminal and press __Enter__. This will install the source package to your current version of R.
 
	```
	R CMD INSTALL sqlBatchInsertR
	```

## Usage and Features

__This has currently been tested for use with Microsoft SQL Server.__

Below are the main functions of the package. 

```r
sqlBatchInsert(dbconn, df, dbtable, nrecords = 1000)
```
- Inserts a data frame into a database table in a transaction using a list of parameterized INSERT statements.

```r
sqlTransaction(dbconn, statement, prompt = TRUE, addl_text = NULL)
```
- Prompts the user to commit or rollback the results of a SQL INSERT, UPDATE, or DELETE statement.

```r
sqlRowsAffected()
```
- Returns the number of rows affected in a database table when sqlBatchInsert() or sqlTransaction() are successfully executed.

```r
sqlOdbcErrors()
```
- Returns a list of ODBC errors after sqlBatchInsert() or sqlTransaction() fails to execute.

## Documentation

Please refer to the
[Wiki](https://github.com/nicholas-alonzo/sqlBatchInsertR/wiki) for additional documentation including use cases, benchmarks, and limitations.

## Contributing

- 🦾 Share ideas for feature enhancements [here](https://github.com/nicholas-alonzo/sqlBatchInsertR/discussions/categories/enhancements). 
- ‼️ Raise issues regarding functionality and share solutions [here](https://github.com/nicholas-alonzo/sqlBatchInsertR/discussions/categories/issues).
- 📓 Chat about anything and everything [here](https://github.com/nicholas-alonzo/sqlBatchInsertR/discussions/categories/general).
- ✋ Ask for help and share solutions [here](https://github.com/nicholas-alonzo/sqlBatchInsertR/discussions/categories/help).
- 💌 Share with me if this package is helpful [here](https://github.com/nicholas-alonzo/sqlBatchInsertR/discussions/categories/kind-words).

## License
sqlBatchInsertR is released under the [GNU General Public License v2.0](https://github.com/nicholas-alonzo/sqlBatchInsertR/blob/main/LICENSE).
