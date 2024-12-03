package main

import "core:os"
import "core:strings"
import "core:strconv"
import "core:text/regex"

data: []u8

read_input :: proc(filepath: string) {
    ok: bool
    data, ok = os.read_entire_file(filepath)
    if !ok do panic("Could not read input file")
}

delete_input :: proc() {
    delete(data)
}

scan_and_mul :: proc(r: regex.Regular_Expression) -> int {
    result := 0
    enabled := true
    
    args: [dynamic][2]int
    defer delete(args)

    it := string(data)
    for line in strings.split_lines_iterator(&it) {
        idx := 0
        end := len(line)

        for idx < end {
            capture, ok := regex.match_and_allocate_capture(r, line[idx:end])
            defer regex.destroy_capture(capture)
            if !ok do break

            if capture.groups[0] == "do()" {
                enabled = true
            } else if capture.groups[0] == "don't()" {
                enabled = false
            } else if enabled {
                result += strconv.atoi(capture.groups[1]) *
                    strconv.atoi(capture.groups[2])
            }
            idx += capture.pos[0][1]
        }
    }

    return result
}

part1 :: proc() -> int {
    r, _ := regex.create(`mul\((\d+),(\d+)\)`, {regex.Flag.Global})
    defer regex.destroy_regex(r)
    return scan_and_mul(r)
}

part2 :: proc() -> int {
    r, _ := regex.create(`mul\((\d+),(\d+)\)|do\(\)|don't\(\)`, {regex.Flag.Global})
    defer regex.destroy_regex(r)
    return scan_and_mul(r)
}
