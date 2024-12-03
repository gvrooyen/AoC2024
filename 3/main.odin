package main

import "core:fmt"

main :: proc() {
    fmt.println("Advent of Code 2024")
    fmt.println("-------------------")
    read_input("input.txt")
    fmt.println("Part 1: ", part1())
    fmt.println("Part 2: ", part2())
    delete_input()
}
