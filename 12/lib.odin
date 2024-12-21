package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:log"

field: [dynamic][dynamic]u8
rows: int
cols: int

Region :: struct {
    area: int,
    peri: int,
}

Context :: struct {
    visited: [dynamic][dynamic]bool,
    region: [dynamic]Region,
}

context_init :: proc(ctx: ^Context) {
    for r in 0..<rows {
        new_row := make([dynamic]bool, cols)
        append(&ctx.visited, new_row)
    }
}

context_destroy :: proc(ctx: ^Context) {
    for row in ctx.visited do delete(row)
    delete(ctx.visited)
    delete(ctx.region)
}

read_input :: proc(filepath: string) {
    data: []u8
    defer delete(data)
    ok: bool
    data, ok = os.read_entire_file(filepath)
    if !ok do panic("Could not read input file")
    it := string(data)
    row := 0
    for line in strings.split_lines_iterator(&it) {
        new_row: [dynamic]u8
        for col in 0..<len(line) {
            append(&new_row, line[col])
        }
        append(&field, new_row)
        row += 1
    }
    rows = row
    cols = len(field[0])
}

delete_input :: proc() {
    for row in field do delete(row)
    delete(field)
}

within_bounds :: proc(row, col: int) -> bool {
    return row >= 0 && row < rows && col >= 0 && col < cols
}

flood_fill :: proc(row, col: int, ctx: ^Context, crop: u8 = 0) {
    if ctx.visited[row][col] || !within_bounds(row, col) do return
    c: u8
    if crop == 0 do c = field[row][col]; else do c = crop
    ctx.visited[row][col] = true

    idx := len(ctx.region) - 1
    ctx.region[idx].area += 1

    delta := [4][2]int{{-1,0}, {1,0}, {0,-1}, {0,1}}
    for d in delta {
        pos := [2]int{row, col} + d
        if within_bounds(pos[0], pos[1]) {
            if field[pos[0]][pos[1]] != c {
                ctx.region[idx].peri += 1
            } else {
                flood_fill(pos[0], pos[1], ctx, c)
            }
        } else do ctx.region[idx].peri += 1
    }
}

part1 :: proc() -> int {
    result := 0

    // Create a region struct with an area and peri.
    //   - rune is not needed here, only used to colour contiguous regions
    // Create a visited rows x cols array
    // Traverse field extracting regions from unvisited positions (flood fill).

    ctx := Context{}
    context_init(&ctx)
    defer context_destroy(&ctx)

    for row in 0..<rows {
        for col in 0..<cols {
            if !ctx.visited[row][col] {
                append(&ctx.region, Region{})
                flood_fill(row, col, &ctx)
            }
        }
    }

    for r in ctx.region do result += r.area * r.peri

    return result
}

part2 :: proc() -> int {
    result := 0

    return result
}
