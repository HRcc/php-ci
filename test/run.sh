#!/bin/bash
set -eo pipefail

[ "$DEBUG" ] && set -x

pass () {
  echo -e "\033[0;32mPASS: $1\033[0m"
}

fail () {
  echo -e "\033[0;31mFAIL: $1\033[0m" && exit 1
}

# Set current working directory to the directory of the script
cd "$(dirname "$0")"

dockerImage="hrcc/php-ci"

echo "Testing $dockerImage..."

if ! docker inspect "$dockerImage" &> /dev/null; then
    echo $'\timage does not exist!'
    false
fi

## TESTS

# Check if $LANG is set
if docker run $dockerImage echo $LANG | grep -q 'en_US.UTF-8'; then
  pass "LANG is set"
else
  fail "LANG is not set"
fi

# Check if PHP 7.2 is available
if docker run $dockerImage php -v | grep -q 'PHP 7.2'; then
  pass "PHP 7.2 is available"
else
  fail "PHP 7.2 is not available"
fi

# Check if Dockerize is available
if docker run $dockerImage dockerize -version | grep -q '0.6.1'; then
  pass "Dockerize is available"
else
  fail "Dockerize is not available"
fi

# Check if composer is available
if docker run $dockerImage composer --version | grep -q 'Composer version'; then
  pass "Composer is available"
else
  fail "Composer is not available"
fi

# Check if Node.js is available
if docker run $dockerImage node -v | grep -q 'v10'; then
  pass "Node.js is available"
else
  fail "Node.js is not available"
fi

echo -e "\n\033[0;32mSUCCESS\033[0m"