st2ints(s) = [parse(Int, s[f]) for f in findall(r"(-*[0-9]+)", s)] 
input = [(match(r"([a-z]+) ", s)[1] == "on", st2ints(s)) for s in readlines("22.txt")]

function netVolume(cubes)
    if length(cubes) == 0 return 0 end
    if length(cubes) == 1 return cubes[1][1] * volume(cubes[1][2]...) end

    (is_on, cube), rest = cubes[1], cubes[2:end]
    if !is_on return netVolume(rest) end
    itxs = itx(cube, rest)

    volume(cube...) - netVolume(itxs) + netVolume(rest)
end

function itx(cube, rest)
    itxs = []
    for (_, other) in rest
        newCube = tinyCube(cube, other)
        if volume(newCube...) > 0
            append!(itxs, [(true, newCube)])
        end
    end
    itxs
end

function tinyCube(cube, other)
    [
        max(cube[1], other[1]),
        min(cube[2], other[2]),
        max(cube[3], other[3]),
        min(cube[4], other[4]),
        max(cube[5], other[5]),
        min(cube[6], other[6])
    ]
end

function volume(X1,X2,Y1,Y2,Z1,Z2)
    max(X2 - X1 + 1, 0) * max(Y2 - Y1 + 1, 0) * max(Z2 - Z1 + 1, 0)
end

println("Part 1: ", netVolume(input[1:20]))
println("Part 2: ", netVolume(input))
