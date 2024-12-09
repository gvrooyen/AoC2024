package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:log"

space :: -1
filesystem: [dynamic]int

// All the files in the filesystem, as `{position, length}` pairs. The index in the array is the ID.
file_blocks: [dynamic][2]int

// All the free blocks in the filesystem, as `{position, length}` pairs
free_blocks: [dynamic][2]int

read_input :: proc(filepath: string) {
    ok: bool
    data: []u8
    defer delete(data)
    data, ok = os.read_entire_file(filepath)
    if !ok do panic("Could not read input file")

    is_file := true
    id := 0
    i := 0
    for ascii in data {
        c := ascii - 48
        if c < 0 || c > 9 do break
        if is_file {
            for _ in 0..<c do append(&filesystem, id)
            if c > 0 do append(&file_blocks, [2]int{i, int(c)})
            id += 1
        } else {
            for _ in 0..<c do append(&filesystem, space)
            if c > 0 do append(&free_blocks, [2]int{i, int(c)})
        }
        is_file = !is_file
        i += int(c)
    }
}

delete_input :: proc() {
    delete(filesystem)
    delete(file_blocks)
    delete(free_blocks)
}

checksum :: proc(fs: ^[dynamic]int) -> (result: int) {
    for i := 0; i < len(fs); i += 1 {
        if fs[i] > 0 do result += i * fs[i]
    }
    return
}

part1 :: proc() -> int {
    fs: [dynamic]int
    defer delete(fs)
    for i in filesystem do append(&fs, i)

    head := 0
    tail := len(fs)-1
    for {
        for fs[head] != space do head += 1
        for fs[tail] == space do tail -= 1
        if head > tail do break
        fs[head] = fs[tail]
        fs[tail] = space
    }

    return checksum(&fs)
}

part2 :: proc() -> int {
    fs: [dynamic]int
    defer delete(fs)
    for i in filesystem do append(&fs, i)
    
    for tail := len(file_blocks) - 1; tail >= 0; tail -= 1 {
        size := file_blocks[tail][1]
        for i in 0..<len(free_blocks) {
            if file_blocks[tail][0] < free_blocks[i][0] do break
            if free_blocks[i][1] >= size {
                for j in 0..<size { 
                    fs[free_blocks[i][0] + j] = tail
                    fs[file_blocks[tail][0] + j] = space
                }
                if free_blocks[i][1] == size {
                    ordered_remove(&free_blocks, i)
                } else {
                    free_blocks[i] += [2]int{size, -size}
                }

                break
            }
        }
    }

    return checksum(&fs)
}
