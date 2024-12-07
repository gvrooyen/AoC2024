package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:log"
import "core:strconv"

data: []u8

read_input :: proc(filepath: string) {
    ok: bool
    data, ok = os.read_entire_file(filepath)
    if !ok do panic("Could not read input file")
}

delete_input :: proc() {
    delete(data)
}

can_calculate :: proc(target: int, values: ^[dynamic]int) -> bool {
    for seq in 0..<(1 << uint(len(values) - 1)) {
        acc := values[0]
        mask := 1
        for i in 1..<len(values) {
            if seq & mask == 0 {
                acc += values[i]
            } else {
                acc *= values[i]
            }
            mask <<= 1
        }
        if acc == target do return true
    }
    return false
}

part1 :: proc() -> int {
    result := 0

    it := string(data)
    for line in strings.split_lines_iterator(&it) {
        values: [dynamic]int
        defer delete(values)
        s_target, _, s_list := strings.partition(line, ":")
        target := strconv.atoi(s_target)
        s_values := strings.split(s_list[1:], " ")
        defer delete(s_values)
        for s in s_values {
            append(&values, strconv.atoi(s))
        }

        if can_calculate(target, &values) do result += target
    }

    return result
}

ternary_inc :: proc(seq: ^[dynamic]int) {
    for i in 0..<len(seq) {
        if seq[i] == 2 {
            seq[i] = 0
        } else {
            seq[i] += 1
            return
        }
    }
}

pow :: proc(base: int, exp: int) -> int {
    acc := base
    for _ in 0..<(exp - 1) {
        acc *= base
    }
    return acc
}

can_calculate2 :: proc(target: int, values: ^[]string) -> bool {
    seq := make([dynamic]int, len(values) - 1)
    defer delete(seq)

    for i in 0..<pow(3, (len(values) - 1)) {
        acc := strconv.atoi(values[0])
        for i in 1..<len(values) {
            switch seq[i-1] {
                case 0: acc += strconv.atoi(values[i])
                case 1: acc *= strconv.atoi(values[i])
                case 2: {
                    s_acc := fmt.aprintf("%d%s", acc, values[i])
                    acc = strconv.atoi(s_acc)
                    delete(s_acc)
                }
            }
        }
        if acc == target do return true
        ternary_inc(&seq)
    }

    return false
}

part2 :: proc() -> int {
    result := 0

    it := string(data)
    for line in strings.split_lines_iterator(&it) {
        s_target, _, s_list := strings.partition(line, ":")
        target := strconv.atoi(s_target)
        values := strings.split(s_list[1:], " ")
        if can_calculate2(target, &values) do result += target
        delete(values)
    }

    return result
}
