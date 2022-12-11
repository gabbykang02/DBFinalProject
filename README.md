# DBFinalProject

## Populating data
Run all sql files in insert_files folder in order to populate the database. The sql files with the _small moniker are subsets of full datasets specified in the project phase writeup.

## Running
**tsv_to_sql.ipynb** converts data files (.tsv and .csv) to SQL statements. You may toggle iterate_all to run the INSERT statement threading into a subset of the raw data (in order to reduce the file size).

**report_generation.py** offers command line terminal based interaction with the database. Modify login information in the pymysql command to connect to a specific database.

**report_generation.ipynb** offers notebook based inteeraction with the database. In order to utilize interactive charts in python, you must use ipynb for GetStatCumulative and GetTwitchStats stored procedures.
