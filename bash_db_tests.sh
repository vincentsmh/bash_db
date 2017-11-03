#!/bin/bash

source bash_db
source bash_unittest/bash_unittest

##### Test cases #####
# Please add unit test cases in the following. The unit test function should be
# started with 'test_'
function test_create_table()
{
  local db_dir="${HOME}/.bash_db/$(echo 'test_table' | base64)"
  create_table "test_table" "field1" "field2" "field3"
  assert_file_exist "${db_dir}"

  local line="$(echo 'field1'|base64)_$(echo 'field2'|base64)"
  line="${line}_$(echo 'field3'|base64)"
  assert_eq "${line}" "$(head -n 1 ${db_dir})"
  assert_eq "0_6_6_6" "$(cat ${db_dir} | sed -n 2p)"

  rm -rf ${db_dir}
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
  local test_db_table="${DB_DIR}/$(echo ${tb_name} | base64)"
  create_table "${tb_name}" "field1" "field2" "field3"

  for i in $(seq 1 10); do
    local v=$(printf "%-${i}s" "v")
    v=$(echo ${v// /v}) # replace " " as "v"
    insert_record "${tb_name}" "${v}" "${v}" "${v}"

    if [ $i -le 6 ]; then
      assert_eq "${i}_6_6_6" "$(cat ${test_db_table} | sed -n 2p)"
    else
      assert_eq "${i}_${i}_${i}_${i}" "$(cat ${test_db_table} | sed -n 2p)"
    fi

    local nth=$(($i + 2))
    assert_eq "${i}_${v}_${v}_${v}" \
      "$(cat ${test_db_table} | sed -n ${nth}p)"
  done

  # Read all data
  read_all ${tb_name} "tb_record"
  for i in $(seq 1 10); do
    v=$(printf "%-${i}s" "v")
    v=$(echo ${v// /v})
    assert_eq "${tb_record[$i,'field1']}" "${v}"
    assert_eq "${tb_record[$i,'field2']}" "${v}"
    assert_eq "${tb_record[$i,'field3']}" "${v}"
  done

  unset tb_record
  rm -rf ${test_db_table}
}

function test_set_db_dir()
{
  local db_dir="${HOME}/.cn/db"
  set_db_dir "${db_dir}"
  assert_eq "${DB_DIR}" "${db_dir}"

  rm -rf ${db_dir}
}

### Main ###
unittest $0
