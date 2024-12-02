package main

import "core:os"
import "core:strings"
import "core:strconv"

file: []u8

read_input :: proc(filepath: string) {
    ok: bool
    file, ok = os.read_entire_file(filepath)
    if !ok do panic("Could not read input file")
}

delete_input :: proc() {
    delete(file)
}

is_safe :: proc(nums: []int) -> bool {
    asc := true
    n := nums[0]
    last := nums[1]
    if (n == last) || abs(n - last) > 3 do return false
    if last < n do asc = false

    for i := 2; i < len(nums); i += 1 {
        n = nums[i]
        if (asc && n <= last) || (!asc && n >= last) || abs(n - last) > 3 do return false
        last = n
    }

    return true
}

parse_line :: proc(nums: ^[dynamic]int, line: string) {
    snums := strings.split(line, " ")
    for s in snums do append(nums, strconv.atoi(s))
    delete(snums)
}

part1 :: proc() -> int {
    nums: [dynamic]int
    defer delete(nums)
    result := 0

    it := string(file)
    for line in strings.split_lines_iterator(&it) {
        clear(&nums)
        parse_line(&nums, line)

        if is_safe(nums[:]) do result += 1
    }

    return result
}

part2 :: proc() -> int {
    nums: [dynamic]int
    defer delete(nums)
    result := 0

    it := string(file)
    for line in strings.split_lines_iterator(&it) {
        clear(&nums)
        parse_line(&nums, line)

        if is_safe(nums[:]) { 
            result += 1
        } else {
            dnums: [dynamic]int
            defer delete(dnums)
            for i := 0; i < len(nums); i += 1 {
                clear(&dnums)
                for j := 0; j < len(nums); j += 1 {
                    if i != j do append(&dnums, nums[j])
                }
                if is_safe(dnums[:]) {
                    result += 1
                    break
                }
            }
        }
    }

    return result
}
