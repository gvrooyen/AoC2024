package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"

data: []u8

read_input :: proc(filepath: string) {
    ok: bool
    data, ok = os.read_entire_file(filepath)
    if !ok do panic("Could not read input file")
}

delete_input :: proc() {
    delete(data)
}

part1 :: proc() -> int {
    result := 0

    it := string(data)
    for line in strings.split_lines_iterator(&it) {
    }

    return result
}

part2 :: proc() -> int {
    result := 0

    it := string(data)
    for line in strings.split_lines_iterator(&it) {
    }

    return result
}
