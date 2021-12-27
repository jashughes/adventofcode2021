CI = CartesianIndex
dir = Dict('.' => CI(0,0), '>' => CI(0, 1), 'v' => CI(1, 0))
arrOfArr2mat(a) = permutedims(reshape(hcat(a...), (length(a[1]), length(a))))

input = arrOfArr2mat([only.(l) for l in split.(readlines("25.txt"), "")])

function nxt(p, val, d = size(input), dir = dir)
    np = p + dir[val]
    np[1] > d[1] && return CI(1, np[2])
    np[2] > d[2] && return CI(np[1], 1)
    np
end

function checkAhead(m, mo, sym, moves)
    aheads = CI{2}[]
    for ci in CartesianIndices(axes(m))
        if m[ci] != sym continue end
        np = nxt(ci, m[ci])
        if m[np] != sym && m[np] != 'v' && mo[np] == '.'
            push!(aheads, np)
            moves += 1
        else
            push!(aheads, ci)
        end
    end
    aheads, moves
end

function step(m)
    mo = Matrix{Char}(undef, size(m)...)
    mo .= '.'
    aheads, moves = checkAhead(m, mo, '>', 0)
    mo[aheads] .= '>'
    aheads, moves = checkAhead(m, mo, 'v', moves)
    mo[aheads] .= 'v'
    mo, moves
end

function cucumberMoves(m)
    turns, moves = 0, 1
    while moves > 0
        m, moves = step(deepcopy(m))
        turns += 1
    end
    turns
end

println("Part 1: ", cucumberMoves(deepcopy(input)))
