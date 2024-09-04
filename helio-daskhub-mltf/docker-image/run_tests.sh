#!/bin/bash

# Usage: docker run -w /srv/test -v $PWD:/srv/test pangeodev/base-notebook:latest ./run_tests.sh base-notebook
echo "Testing docker image {$1}..."

pytest -v tests/test_$1.py 

#EOF
