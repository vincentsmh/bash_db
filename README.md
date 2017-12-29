
Bash Database
=============

This is a simulated database management tool for bash. All tables are stored in
files. This is now suitable for small scale database management only.


Quick Start
===========

Clone this project and save `bash_db` along with your project. Then `source` it.

```bash
#!/bin/bash
source bash_db
```


Database Operation Commands
===========================

## Create a table

```bash
create_table TABLE_NAME FIELD_NAME1 [FIELD_NAME2 ...]
```

## Insert record to a table

```bash
insert_record TABLE_NAME FIELD1_VALUE FIELD2_VALUE FIELD3_VALUE
```

## Read all values from a table

```bash
read_all TABLE_NAME RECORD_NAME
```

Read all values from `TABLE_NAME` into the given variable. The values will be
stored in the variable as a two dimention index format which is
`variable[Index, FIELD_NAME_idx]`. The following is an example to read all data
into `tb_record`.

```bash
read_all ${tb_name} "tb_record"
for i in $(seq 1 10); do
  echo "${tb_record[$i,'field1']}"
  echo "${tb_record[$i,'field2']}"
  echo "${tb_record[$i,'field3']}"
done
```

## Set the database directory

```bash
set_db_dir DB_DIR
```

After setting a directory, all table will be written/read to/from under the
directory. The default directory is `~/.bash_db/`.

A database directory can treated as a database. In a database, it cannot
possess two tables with the same name but in different database it can.

## Check if a table is existed

```bash
table_exist TABLE_NAME
```
