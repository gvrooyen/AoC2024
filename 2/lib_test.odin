package main

import "core:testing"
import "core:slice"
import "core:log"

TEST_RESULT1 :: 2
TEST_RESULT2 :: 4

@(test)
test_solutions :: proc(t: ^testing.T) {
    read_input("test.txt")
    testing.expect_value(t, part1(), TEST_RESULT1)
    testing.expect_value(t, part2(), TEST_RESULT2)
    delete_input()
}
