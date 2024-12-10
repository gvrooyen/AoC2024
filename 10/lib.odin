package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:log"

topo: [dynamic][dynamic]int
heads: [dynamic][2]int
rows: int
cols: int

read_input :: proc(filepath: string) {
    data: []u8
    defer delete(data)
    ok: bool
    data, ok = os.read_entire_file(filepath)
    if !ok do panic("Could not read input file")
    it := string(data)
    row := 0
    for line in strings.split_lines_iterator(&it) {
        append(&topo, [dynamic]int{})
        for col in 0..<len(line) {
            append(&topo[row], int(line[col] - 48))
            if line[col] == 48 do append(&heads, [2]int{row, col})
        }
        row += 1
    }
    rows = row
    cols = len(topo[0])
}

delete_input :: proc() {
    for t in topo do delete(t)
    delete(topo)
    delete(heads)
}

within_bounds :: proc(pos: [2]int) -> bool {
    return pos[0] >= 0 && pos[0] < rows && pos[1] >= 0 && pos[1] < cols
}

find_trail :: proc(peaks: ^map[[2]int]bool, pos: [2]int, rating: ^int = nil) {
    z := topo[pos[0]][pos[1]]
    if z == 9 {
        peaks[pos] = true
        if rating != nil do rating^ += 1
    } else {
        delta := [4][2]int{{-1,0}, {1,0}, {0,-1}, {0,1}}
        for d in delta {
            newpos := pos + d
            if within_bounds(newpos) && topo[newpos[0]][newpos[1]] == z + 1 {
                find_trail(peaks, newpos, rating)
            }
        }
    }
    return
}

part1 :: proc() -> (score: int) {
    for h in heads {
        peaks := make(map[[2]int]bool)
        defer delete(peaks)
        find_trail(&peaks, h)
        score += len(peaks)
    }
    return
}

part2 :: proc() -> int {
    rating := 0
    for h in heads {
        peaks := make(map[[2]int]bool)
        defer delete(peaks)
        find_trail(&peaks, h, &rating)
    }
    return rating
}
