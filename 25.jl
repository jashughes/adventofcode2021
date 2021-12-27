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


function step(m)
    mo = Matrix{Char}(undef, size(m)...)
    mo .= '.'
    moves, lefts, downs = 0, CI{2}[], CI{2}[]
    for ci in CartesianIndices(axes(m))
        if m[ci] != '>' continue end
        np = nxt(ci, m[ci])
        if m[np] == '.'
            push!(lefts, np)
            moves += 1
        else
            push!(lefts, ci)
        end
    end

    mo[lefts] .= '>'

    for ci in CartesianIndices(axes(m))
        if m[ci] != 'v' continue end
        np = nxt(ci, m[ci])
        if m[np] != 'v' && mo[np] == '.'
            push!(downs, np)
            moves += 1
        else
            push!(downs, ci)
        end
    end

    mo[downs] .= 'v'

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

