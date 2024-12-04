package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:log"

grid: [dynamic][dynamic]u8

read_input :: proc(filepath: string) {
    data: []u8
    defer delete(data)

    ok: bool
    data, ok = os.read_entire_file(filepath)
    if !ok do panic("Could not read input file")
    it := string(data)
    for line in strings.split_lines_iterator(&it) {
        append(&grid, [dynamic]u8{})
        n := len(grid)
        for i in 0..<len(line) do append(&grid[n-1], line[i])
    }
}

delete_input :: proc() {
    for row in grid do delete(row)
    delete(grid)
}

scan :: proc (word: string, row: int, col: int, dr: int, dc: int) -> int {
    r := row
    c := col
    for i in 0..<len(word) {
        if r < 0 || c < 0 || r >= len(grid) || c >= len(grid[r]) || grid[r][c] != word[i] do return 0
        r += dr
        c += dc
    }
    return 1
}

part1 :: proc() -> int {
    result := 0
    for row in 0..<len(grid) {
        for col in 0..<len(grid[row]) {
            for dr in -1..=1 {
                for dc in -1..=1 {
                    result += scan("XMAS", row, col, dr, dc)
                }
            }
        }
    }
    return result
}

part2 :: proc() -> int {
    result := 0
    for row in 0..<(len(grid)-2) {
        for col in 0..<(len(grid[row])-2) {
            if ((scan("MAS", row, col, 1, 1) == 1 || scan("SAM", row, col, 1, 1) == 1) &&
                (scan("MAS", row, col+2, 1, -1) == 1 || scan("SAM", row, col+2, 1, -1) == 1)) {
                    result += 1
            }
        }
    }
    return result
}
