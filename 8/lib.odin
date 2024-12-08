package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:log"

antenna: map[rune][dynamic][2]int
cols: int
rows: int

read_input :: proc(filepath: string) {
    data: []u8
    defer delete(data)
    ok: bool
    data, ok = os.read_entire_file(filepath)
    if !ok do panic("Could not read input file")
    it := string(data)
    row := 0
    antenna = make(map[rune][dynamic][2]int)

    rows = 0
    for line in strings.split_lines_iterator(&it) {
        rows += 1
        col := 0
        for c in line {
            if c != '.' {
                if c not_in antenna do antenna[c] = [dynamic][2]int{}
                append(&antenna[c], [2]int{row, col})
            }
            col += 1
        }
        cols = col
        row += 1
    }
}

delete_input :: proc() {
    for c in antenna do delete(antenna[c])
    delete(antenna)
}

within_bounds :: proc(pos: [2]int) -> bool {
    return pos[0] >= 0 && pos[0] < rows && pos[1] >= 0 && pos[1] < cols
}

part1 :: proc() -> int {
    antinodes := make(map[[2]int]bool)
    defer delete(antinodes)

    for c in antenna {
        coords := antenna[c]
        for a1 in 0..<len(coords)-1 {
            for a2 in a1+1..<len(coords) {
                dx := coords[a2][0] - coords[a1][0]
                dy := coords[a2][1] - coords[a1][1]
                n1 := [2]int{coords[a1][0] - dx, coords[a1][1] - dy}
                n2 := [2]int{coords[a2][0] + dx, coords[a2][1] + dy}
                if within_bounds(n1) do antinodes[n1] = true
                if within_bounds(n2) do antinodes[n2] = true
            }
        }
    }

    return len(antinodes)
}

part2 :: proc() -> int {
    antinodes := make(map[[2]int]bool)
    defer delete(antinodes)

    for c in antenna {
        coords := antenna[c]
        for a1 in 0..<len(coords)-1 {
            for a2 in a1+1..<len(coords) {
                antinodes[coords[a1]] = true
                antinodes[coords[a2]] = true
                dx := coords[a2][0] - coords[a1][0]
                dy := coords[a2][1] - coords[a1][1]
                n1 := [2]int{coords[a1][0] - dx, coords[a1][1] - dy}
                n2 := [2]int{coords[a2][0] + dx, coords[a2][1] + dy}
                for within_bounds(n1) {
                    antinodes[n1] = true
                    n1 -= [2]int{dx, dy}
                }
                for within_bounds(n2) {
                    antinodes[n2] = true
                    n2 += [2]int{dx, dy}
                }
            }
        }
    }

    return len(antinodes)
}
