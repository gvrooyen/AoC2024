package main

import "core:testing"

TEST_RESULT1 :: 41
TEST_RESULT2 :: 6

@(test)
test_solutions :: proc(t: ^testing.T) {
    read_input("test.txt")
    testing.expect_value(t, part1(), TEST_RESULT1)
    testing.expect_value(t, part2(), TEST_RESULT2)
    delete_input()
}
