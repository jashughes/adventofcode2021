input = split.(readlines("02.txt"), " ")

function move(d, pos)
    n = parse(Int, d[2])
    d[1] == "forward" && return pos + [n, 0]
    d[1] == "down" && return pos + [0, n]
    d[1] == "up" && return pos - [0, n]
end

function move_and_aim(d, pos)
    n = parse(Int, d[2])
    d[1] == "forward" && return pos + [n, n * pos[3], 0]
    d[1] == "down" && return pos + [0, 0, n]
    d[1] == "up" && return pos - [0, 0, n]
end

function solve(input, f, init)
    for i in input
        init = f(i, init)
    end
    init[1] * init[2]
end

println("Part 1: ", solve(input, move, [0,0]))
println("Part 2: ", solve(input, move_and_aim, [0,0,0]))