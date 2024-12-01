package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:log"
import "core:slice"

data: []u8
foo: int
list_a: [dynamic]int
list_b: [dynamic]int
bar: int

read_input :: proc(filepath: string) {
    ok: bool
    data, ok = os.read_entire_file(filepath)
    if !ok do panic("Could not read input file")
}

delete_input :: proc() {
    delete(data)
    delete(list_a)
    delete(list_b)
}

part1 :: proc() -> int {
    result := 0

    it := string(data)
    for line in strings.split_lines_iterator(&it) {
        s1 := line[0:strings.index(line, " ")]
        s2 := line[strings.last_index(line, " ")+1:]
        append(&list_a, strconv.atoi(s1))
        append(&list_b, strconv.atoi(s2))
    }

    slice.sort(list_a[:])
    slice.sort(list_b[:])

    for i := 0; i < len(list_a); i += 1 {
        result += abs(list_a[i] - list_b[i])
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
