
input = parse.(Int, last.(split.(readlines("21.txt"), ":")))
roll(d) = [mod1(x, 100) for x in d:d+2]

function play(p1, p2)
    d = 1
    scores = [0, 0]
    pos = [p1, p2]
    turn = 1
    nd = 0
    while maximum(scores) < 1000
        rolls = roll(d)
        nd += 3
        d = rolls[3] + 1
        pos[turn] = mod1(pos[turn] + sum(rolls), 10)
        scores[turn] += pos[turn]
        turn = mod1(turn + 1, 2)
    end
    minimum(scores) * nd
end

println("Part 1: ", play(input...))

freq = Dict(3=>1, 4=>3,5=>6,6=>7,7=>6,8=>3,9=>1)

function brokenftw(p1,p2,s1,s2,n1,n2, freq)
    s1 >= 21 && return [n1, 0]
    s2 >= 21 && return [0, n2]
    
    wins = [0, 0]
    for (k1, v1) in freq
        for (k2, v2) in freq
            wins += ftw(
                mod1(k1 + p1, 10),      mod1(k2 + p2, 10),
                mod1(k1 + p1, 10) + s1, mod1(k2 + p2, 10) + s2,
                v1 * n1, v2 * n2, freq
            )
        end
    end
    wins
end



freq = Dict(3=>1, 4=>3,5=>6,6=>7,7=>6,8=>3,9=>1)

function ftw(p1,p2,s1=0,s2=0)
    s2 >= 21 && return [0, 1]
    
    wins = [0, 0]
    for (k, v) in freq
        pn = mod1(p1 + k, 10)
        n2, n1 = ftw(p2, pn, s2, s1 + pn)
        wins += [n1, n2] * v
    end
    wins
end

println("Part 2: ", maximum(ftw(input...))