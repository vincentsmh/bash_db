
.PHONY: test

all:
	@echo
	@echo "make [commands]"
	@echo "  - test: run unit test"
	@echo

bash_unittest/bash_unittest:
	@git clone https://github.com/vincentsmh/bash_unittest

test: bash_unittest/bash_unittest
	bash bash_db_tests.sh
