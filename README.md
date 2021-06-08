# sqlBatchInsertR

sqlBatchInsertR is built on top of the RODBC package and aims to extend its functionality. It provides an efficient way of inserting a data frame into a database table and handling SQL DML statements. 

## Inspiration and Motivation

In the summer of 2016 I volunteered at a non-profit community health clinic not knowing it would eventually be the start to a full-time career. My first big project was simply to compare Excel records to records in a MS SQL Server database. What records in the Excel file exist and don't exist in the database and vice-versa.

To accomplish the task, I chose to use R and the RODBC package. When that was handled, phase two began and I started to keep track of the Excel records in more detail. This involved data modeling and then building out R scripts to insert and update data appropriately. One of the setbacks to this was the increasing amount of records in the Excel files. The RODBC package offers ```sqlSave()``` for writing to a database table, but it couldn't keep up with the demand. I wasn't the only one that noticed this; there were many others raising this issue on Stack Overflow, but no solution provided.

This is when I had the inspiration to write my own functions that could accomplish the same thing, but much more efficiently. I started writing code in 2017 until I reached the solution of creating batches of parameterized INSERT statements. It was a __major__ speed up and I became reliant on it for other projects. The code lived in a few R scripts until I decided to make it an official internal package in 2018.

It's now 2021 and I've decided to release it to the public in hopes it will be useful for others. What's special about this package is it's minimal. I use only base R for data manipulation and RODBC for database connectivity and transactions. I'm certain there's more enhancements that can be made, so feel free to start a discussion [here](https://github.com/nicholas-alonzo/sqlBatchInsertR/discussions/categories/enhancements). __This has currently been tested in and for the Microsoft SQL Server enviroment. Please do not create issues as it is still in a pre-release state.__

Nicholas Alonzo  
6/8/2021

## Prerequisites

- [R](https://cloud.r-project.org/) (>= 4.0.0)
- [RODBC](https://cran.r-project.org/web/packages/RODBC/) (>= 1.3.0)

## Installation

### In Release: Source Package

1. Download the source package (tar.gz) of the [current release](https://github.com/nicholas-alonzo/sqlBatchInsertR/releases).

2. In R, copy the following code into the console. 

	```r
	install.packages("sqlBatchInsertR_#.#.#.tar.gz", repos = NULL, type = "source", dependencies = TRUE)
	```
3. Change the first argument to be the path of the downloaded (tar.gz) file.

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

5. Copy the following command into terminal and press __Enter__. This will install the source package
 
	```
	R CMD INSTALL sqlBatchInsertR
	```

## Usage and Features
__This has currently been tested in and for the Microsoft SQL Server enviroment. Please do not create issues as it is still in a pre-release state.__

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

Please refer to the sqlBatchInsertR
[Wiki](https://github.com/nicholas-alonzo/sqlBatchInsertR/wiki) for additional documentation including use cases and benchmarks.

## Contributing

Start a discussion for ideas on current or new [Feature Enhancements](https://github.com/nicholas-alonzo/sqlBatchInsertR/discussions/categories/enhancements).

## License
sqlBatchInsertR is released under the [GNU General Public License v2.0](https://github.com/nicholas-alonzo/sqlBatchInsertR/blob/main/LICENSE).
