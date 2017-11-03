
Bash Database
=============

This is a simulated database management tool for bash. All table are stored in
files as string.


Quick Start
===========

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

Read all value from TABLE_NAME into the given variable name. The values will be
stored in the variable name as a two dimention index format which is
`[Index, FIELD_NAME]`. The following is an example.

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

After you set a directory, all table will be written/read to/from under the
directory. The default directory is `~/.bash_db/`.

## Check if a table is existed

```bash
table_exist TABLE_NAME
```
