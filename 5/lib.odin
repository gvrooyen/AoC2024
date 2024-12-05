package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:log"
import "core:time"
import "core:slice"

updates: [dynamic][dynamic]int
smaller: map[int][dynamic]int

read_input :: proc(filepath: string) {
    data: []u8
    defer delete(data)
    smaller = make(map[int][dynamic]int)
    pairs: [dynamic][2]int
    defer delete(pairs)

    ok: bool
    data, ok = os.read_entire_file(filepath)
    if !ok do panic("Could not read input file")

    it := string(data)
    for line in strings.split_lines_iterator(&it) {
        if line == "" do break
        n1, _, n2 := strings.partition(line, "|")
        append(&pairs, [2]int{strconv.atoi(n1), strconv.atoi(n2)})
    }

    for p in pairs {
        if !(p[1] in smaller) {
            smaller[p[1]] = [dynamic]int{p[0]}
        } else {
            append(&(smaller[p[1]]), p[0])
        }
    }

    for line in strings.split_lines_iterator(&it) {
        pages: [dynamic]int
        nums := strings.split(line, ",")
        defer delete(nums)
        for n in nums {
            append(&pages, strconv.atoi(n))
        }
        append(&updates, pages)
    }
}

delete_input :: proc() {
    for u in updates do delete(u)
    delete(updates)
    for x in smaller do delete(smaller[x])
    delete(smaller)
}

is_in_order :: proc(smaller: ^map[int][dynamic]int, update: ^[dynamic]int) -> bool {
    for i in 0..<len(update)-1 {
        current := update[i]
        for j in i+1..<len(update) {
            next := update[j]
            if (current == next) || slice.contains(smaller[current][:], next) {
                return false
            }
        }
    }
    return true
}

part1 :: proc() -> int {
    // Build up a map that relates a number to a list of numbers that is smaller than itself.
    // Whe can then iterate over the update sequence from left to right, and ensure that none
    // of the values _after_ the current one appear in the "known to be smaller than me" list,
    // or is the number itself
    result := 0

for i in 0..<len(updates) {
        if is_in_order(&smaller, &updates[i]) {
            result += updates[i][len(updates[i]) / 2]
        }
    }

    return result
}

part2 :: proc() -> int {
    result := 0

    for i in 0..<len(updates) {
        if !is_in_order(&smaller, &updates[i]) {
            slice.sort_by(updates[i][:], proc(i: int, j: int) -> bool {
                return slice.contains(smaller[j][:], i)
            })
            result += updates[i][len(updates[i]) / 2]
        }
    }

    return result
}
