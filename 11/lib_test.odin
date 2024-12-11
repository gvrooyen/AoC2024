package main

import "core:testing"

TEST_RESULT1 :: 55312

@(test)
test_count_digits :: proc(t: ^testing.T) {
    testing.expect_value(t, count_digits(5), 1)
    testing.expect_value(t, count_digits(47), 2)
    testing.expect_value(t, count_digits(655), 3)
    testing.expect_value(t, count_digits(9999), 4)
}

@(test)
test_split_digits :: proc(t: ^testing.T) {
    a, b := split_digits(12, 2)
    testing.expect_value(t, a, 1)
    testing.expect_value(t, b, 2)
    a, b = split_digits(1234, 4)
    testing.expect_value(t, a, 12)
    testing.expect_value(t, b, 34)
    a, b = split_digits(123000, 6)
    testing.expect_value(t, a, 123)
    testing.expect_value(t, b, 0)
}

@(test)
test_solutions :: proc(t: ^testing.T) {
    read_input("test.txt")
    testing.expect_value(t, part1(), TEST_RESULT1)
    delete_input()
}
