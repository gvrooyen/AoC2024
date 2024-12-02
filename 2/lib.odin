package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:log"

file: []u8

read_input :: proc(filepath: string) {
    ok: bool
    file, ok = os.read_entire_file(filepath)
    if !ok do panic("Could not read input file")
}

delete_input :: proc() {
    delete(file)
}

part1 :: proc() -> int {
    result := 0

    it := string(file)
    safe: for line in strings.split_lines_iterator(&it) {
        nums := strings.split(line, " ")
        defer delete(nums)

        asc := true
        n := strconv.atoi(nums[0])
        last := strconv.atoi(nums[1])
        if (n == last) || abs(n - last) > 3 do continue safe
        
        if last < n do asc = false

        for i := 2; i < len(nums); i += 1 {
            n = strconv.atoi(nums[i])
            if (asc && n <= last) || (!asc && n >= last) || abs(n - last) > 3 do continue safe
            last = n
        }

        result += 1
    }

    return result
}

part2 :: proc() -> int {
    result := 0

    return result
}
