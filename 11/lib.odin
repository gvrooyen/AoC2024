package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:log"

initial: [dynamic]int
memo: map[[2]int]int

read_input :: proc(filepath: string) {
    data: []u8
    defer delete(data)
    memo = make(map[[2]int]int)
    ok: bool
    data, ok = os.read_entire_file(filepath)
    if !ok do panic("Could not read input file")
    it := string(data)
    for line in strings.split_lines_iterator(&it) {
        snum := strings.split(line, " ")
        for s in snum do append(&initial, strconv.atoi(s))
        delete(snum)
    }
}

delete_input :: proc() {
    delete(initial)
    delete(memo)
}

count_digits :: proc(n: int) -> (result: int) {
    result = 0
    nn := n
    for nn > 0 {
        result += 1
        nn /= 10
    }
    return
}

split_digits :: proc(n, n_digits: int) -> (a, b: int) {
    div := 1
    for _ in 0..<n_digits/2 do div *= 10
    a = n / div
    b = n % div
    return
}

blink :: proc(times: int) -> (result: int) {

    clear(&memo)

    count :: proc(n: int, depth: int = 0, limit: int = 25) -> int {
        if depth == limit do return 1
        pos := [2]int{n, depth}
        val := memo[pos]
        if val > 0 do return val
        if n == 0 {
            val := count(1, depth + 1, limit)
            memo[pos] = val
            return val
        } else {
            n_digits := count_digits(n)
            if n_digits % 2 == 0 {
                a, b := split_digits(n, n_digits)
                val := count(a, depth + 1, limit) + count(b, depth + 1, limit)
                memo[pos] = val
                return val
            } else {
                val := count(n * 2024, depth + 1, limit)
                memo[pos] = val
                return val
            }
        }
    }

    for n in initial do result += count(n, limit=times)
    return
}

part1 :: proc() -> int {
    return blink(25)
}

part2 :: proc() -> int {
    return blink(75)
}
