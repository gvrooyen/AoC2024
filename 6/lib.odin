package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:log"

direction :: enum{Up, Right, Down, Left}

delta := [direction][2]int {
    .Up = {-1, 0},
    .Right = {0, 1},
    .Down = {1, 0},
    .Left = {0, -1},
}

dir_char := map[rune]direction {
    '^' = .Up,
    '>' = .Right,
    'v' = .Down,
    '<' = .Left,
}

turn := [direction]direction {
    .Up = .Right,
    .Right = .Down,
    .Down = .Left,
    .Left = .Up,
}

// `true` if the block has an obstruction
grid: [dynamic][dynamic]bool
start_pos: [2]int
start_dir: direction
visited: map[[2]int]bool

read_input :: proc(filepath: string) {
    data: []u8
    defer delete(data)
    ok: bool
    data, ok = os.read_entire_file(filepath)
    if !ok do panic("Could not read input file")

    row := 0
    it := string(data)
    for line in strings.split_lines_iterator(&it) {
        new_row: [dynamic]bool
        col := 0
        for c in line {
            append(&new_row, c == '#')
            if c in dir_char {
                start_pos = {row, col}
                start_dir = dir_char[c]
            }
            col += 1
        }
        append(&grid, new_row)
        row += 1
    }

}

delete_input :: proc() {
    for row in grid do delete(row)
    delete(grid)
    delete(visited)
}

within_bounds :: proc(pos: [2]int) -> bool {
    return pos[0] >= 0 && pos[0] < len(grid) && pos[1] >= 0 && pos[1] < len(grid[0])
}

obstacle_ahead :: proc(pos: [2]int, dir: direction) -> bool {
    new_pos := pos + delta[dir]
    return within_bounds(new_pos) && grid[new_pos[0]][new_pos[1]]
}

mark_visited :: proc() {
    pos := start_pos
    dir := start_dir

    for within_bounds(pos) {
        visited[pos] = true
        for obstacle_ahead(pos, dir) do dir = turn[dir]
        pos = pos + delta[dir]
    }
}

part1 :: proc() -> int {
    visited = make(map[[2]int]bool)
    mark_visited()
    return len(visited)
}

Heading :: struct {
    pos: [2]int,
    dir: direction,
}

part2 :: proc() -> int {
    result := 0

    for track_walk in visited {
        row := track_walk[0]
        col := track_walk[1]
        if !grid[row][col] && !(row == start_pos[0] && col == start_pos[1]) {
            grid[row][col] = true
            visited := make(map[Heading]bool)
            defer delete(visited)
            pos := start_pos
            dir := start_dir
            walk: for within_bounds(pos) {
                h: Heading = {pos, dir}
                if visited[h] {
                    result += 1
                    break walk
                }
                visited[h] = true
                for obstacle_ahead(pos, dir) {
                    dir = turn[dir]
                    h: Heading = {pos, dir}
                    if visited[h] {
                        result += 1
                        break walk
                    }
                    visited[h] = true
                }
                pos = pos + delta[dir]
            }
            grid[row][col] = false
        }
    }
    return result
}
