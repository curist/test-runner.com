#!/bin/bash
set -e

RUNNER="./artifacts/test-runner.com"
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "Running integration tests..."

# Test --help flag
echo -n "Testing --help flag... "
if $RUNNER --help >/dev/null 2>&1; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗ --help failed${NC}"
    exit 1
fi

# Test --version flag
echo -n "Testing --version flag... "
if $RUNNER --version >/dev/null 2>&1; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗ --version failed${NC}"
    exit 1
fi

# Test invalid flag handling
echo -n "Testing invalid flag handling... "
if $RUNNER --invalid-flag >/dev/null 2>&1; then
    echo -e "${RED}✗ Should have failed on invalid flag${NC}"
    exit 1
else
    echo -e "${GREEN}✓${NC}"
fi

# Test invalid flag error message
echo -n "Testing invalid flag error message... "
if $RUNNER --invalid 2>&1 | grep -q "unknown option"; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗ Invalid flag should show 'unknown option' message${NC}"
    exit 1
fi

# Test successful test run (exit code 0)
echo -n "Testing successful test execution... "
if $RUNNER test/assert_test.fnl >/dev/null 2>&1; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗ assert_test.fnl should pass${NC}"
    exit 1
fi

# Create a failing test and test exit code 1
echo -n "Testing failing test exit code... "
echo '{:test-fail (fn [] (assert.= 1 2))}' > test_fail_temp.fnl
trap "rm -f test_fail_temp.fnl" EXIT

if $RUNNER test_fail_temp.fnl >/dev/null 2>&1; then
    echo -e "${RED}✗ Failing test should exit with code 1${NC}"
    exit 1
else
    echo -e "${GREEN}✓${NC}"
fi

echo -e "${GREEN}All integration tests passed!${NC}"