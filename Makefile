
.PHONY: test

all:
	echo -e "make [commands]"
	echo -e "  - test: run unit test"

bash_unittest/bash_unittest:
	@git clone https://github.com/vincentsmh/bash_unittest

test: bash_unittest/bash_unittest
	bash bash_db_tests.sh
