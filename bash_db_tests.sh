#!/bin/bash

source bash_db
source bash_unittest/bash_unittest

##### Test cases #####
# Please add unit test cases in the following. The unit test function should be
# started with 'test_'
function test_create_table()
{
  local db_file="${HOME}/.bash_db/$(_b64e 'test_table')"
  rm -rf ${db_file}
  create_table "test_table" "field1" "field2" "field3"
  assert_file_exist "${db_file}"
  assert_file_empty "${db_file}"

  assert_eq "field1\,field2\,field3" "$(head -n 1 ${db_file}.md)"
  assert_eq "6\,6\,6" "$(cat ${db_file}.md | sed -n 2p)"
  assert_eq "0" "$(cat ${db_file}.md | sed -n 3p)"
  rm -rf ${db_file}
}

function test_exist_table()
{
  local tb_name="test_exist_table"

  rm -rf "$(_table_file ${tb_name})"
  create_table ${tb_name}
  assert_eq "0" "$?"

  create_table ${tb_name}
  assert_eq "1" "$?"
  assert_eq "Table exists" "${bash_db_error}"

  table_exist "${tb_name}"
  assert_eq "0" "$?"

  rm -rf "$(_table_file ${tb_name})"
}

function test_insert_n_read()
{
  local tb_name='test_table'
  local tb_file="$( _table_file "$tb_name" )"
  rm -rf ${tb_file} ${tb_file}.md
  create_table "${tb_name}" "field1" "field2" "field3"

  for idx in $(seq 1 10); do
    local v=$(printf "%-${idx}s" "v")
    v=$(echo ${v// /v}) # replace " " as "v"
    insert_record "${tb_name}" "${v}" "${v}" "${v}"

    if [ $idx -le 6 ]; then
      assert_eq "6\,6\,6" "$(cat ${tb_file}.md | sed -n 2p)"
    else
      assert_eq "${idx}\,${idx}\,${idx}" "$(cat ${tb_file}.md | sed -n 2p)"
    fi

    assert_eq "$idx" "$(cat ${tb_file}.md | sed -n 3p)"
    assert_eq "${idx}\,${v}\,${v}\,${v}" "$(cat ${tb_file} | sed -n ${idx}p)"
  done

  # Read all data
  read_all "${tb_name}" "tb_record"
  local idx=0
  for i in $(seq 1 10); do
    v=$(printf "%-${i}s" "v")
    v=$(echo ${v// /v})
    idx=$(( $i - 1 ))
    assert_eq "${tb_record[$idx,'ID']}" "${i}"
    assert_eq "${tb_record[$idx,'field1']}" "${v}"
    assert_eq "${tb_record[$idx,'field2']}" "${v}"
    assert_eq "${tb_record[$idx,'field3']}" "${v}"
  done

  unset tb_record
  rm -rf ${tb_file} ${tb_file}.md
}

function test_insert_nonexist_table()
{
  local tb_name="non_exist_table"
  insert_record "${tb_name}" "v1" "v2" "v3"
  assert_eq 1 $?
  assert_eq "Table (${tb_name}) doesn't exist" "${bash_db_error}"
}

function test_print_table()
{
  local tb_name="print_table"
  local tb_file="$(_table_file $tb_name)"
  rm -rf ${tb_file} ${tb_file}.md
  create_table "${tb_name}" "field1" "field2" "field3"
  for i in $(seq 1 10); do
    local v=$(printf "%-${i}s" "$i")
    v=$(echo ${v// /v}) # replace " " as "v"
    insert_record "${tb_name}" "${v}" "${v}" "${v}"
  done
  echo -e

  print_table "print_table"
  rm -rf ${tb_file} ${tb_file}.md
}

function test_set_db_dir()
{
  local db_dir="${HOME}/.cn/db"
  set_db_dir "${db_dir}"
  assert_eq "${DB_DIR}" "${db_dir}"

  rm -rf ${db_dir}
}

### Main ###
if [ -z "$1" ]; then
  unittest $0
else
  unittest "$0" "$1"
fi
