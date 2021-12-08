input = split.(readlines("08.txt"), " | ")

di = Dict(4 => 4, 7 => 3, 1 => 2, 8 => 7)

outputs = [split(x[2], " ") for x in input]
println("Part 1: ", sum([count(y -> y in values(di), length.(x)) for x in outputs]))

all_letters = ["a", "b", "c", "d", "e", "f", "g"]
all_sides = ["top", "tl", "tr", "mid", "bl", "br", "bot"]
side2lett = Dict(k => Set(all_letters) for k in all_sides)
easyd = Dict(4 => 4, 3 => 7, 2 => 1, 7 => 8)
num2side = Dict(
    0 => ["top", "tl", "tr", "bl", "br", "bot"],
    1 => ["tr", "br"],
    2 => ["top", "tr", "mid", "bl", "bot"],
    3 => ["top", "mid", "bot", "tr", "br"],
    4 => ["tl", "tr", "mid", "br"],
    5 => ["top", "mid", "bot", "tl", "br"],
    6 => ["top", "mid", "bot", "tl", "bl", "br"],
    7 => ["top", "tr", "br"],
    8 => ["top", "tl", "tr", "bl", "br", "bot", "mid"],
    9 => ["top", "tl", "tr", "br", "bot", "mid"]
)

function count_numbers_per_edge(num2side)
    all_sides = ["top", "tl", "tr", "mid", "bl", "br", "bot"]
    counts = Dict()
    invcounts = Dict()
    for s in all_sides
        counts[s] = sum(s in v for v in values(num2side))
        invcounts[counts[s]] = vcat(get(invcounts, counts[s], []), s)
    end
    counts, invcounts
end

counts, invcounts = count_numbers_per_edge(num2side)

function easy(l, side2lett, num2side, easyd)
    comb = split(l[1] * " " * l[2], " ")
    for c in comb
        nc = length(c)
        if nc in keys(easyd)
            sides = num2side[easyd[nc]]
            for k in sides
                side2lett[k] = intersect(side2lett[k], split(c, ""))
            end
        end
    end
    side2lett
end

function find_unique(d)
    all_letters = string.(["a", "b", "c", "d", "e", "f", "g"])
    for l in all_letters
        if any(d[k] == Set([l]) for k in keys(d))
            for k in keys(d)
                if d[k] != Set([l])
                    d[k] = setdiff(d[k], [l])
                end
            end
        end
    end
    d
end

function matching_options(d)
    for k1 in keys(d)
        if length(d[k1]) == 1
            continue
        end
        matches = [k1]
        for k2 in setdiff(keys(d), [k1])
            if d[k1] == d[k2] push!(matches, k2) end
        end
        if length(matches) == length(d[k1])
            for k in matches
                d[k] = d[k1]
            end
            for k in setdiff(keys(d), matches)
                d[k] = setdiff(d[k], d[k1])
            end
        end
    end
    find_unique(d)
end

function freq_check(l, invcounts)
    comb = unique([Set(split(s, "")) for s in split(l[1] * " " * l[2], " ")])
    all_letters = string.(["a", "b", "c", "d", "e", "f", "g"])
    freq_opts = Dict()
    for l in all_letters
        freq_opts[l] = invcounts[sum(l in c for c in comb)]
    end
    freq_opts
end

function eliminate_by_freq!(d, d2)
    for k2 in keys(d2)
        if length(d2[k2]) == 1
            d[d2[k2][1]] = Set([k2])
        end
    end
    d
end


function decode_line(l, side2lett, num2side, easyd)
    d = easy(l, deepcopy(side2lett), num2side, easyd)
    d2 = freq_check(l, invcounts)
    eliminate_by_freq!(d, d2)
    while sum(length(v) for v in values(d)) > 7
        d = find_unique(d)
        d = matching_options(d)
    end
    d
end

function inv_dict(r)
    Dict(collect(r[k])[1] => k for k in keys(r))
end

function sides2number(sides, num2side)
    sides = Set(sides)
    for k in keys(num2side)
        if Set(num2side[k]) == sides
            return k
        end
    end
end

function word2number(word, rosetta, num2side)
    sides = [rosetta[string(w)] for w in word]
    sides2number(sides, num2side)
end

function array2number(arr)
    parse(Int, join(arr, ""))
end

function solve(input)
    tot = 0
    for i in input
        rosetta = inv_dict(decode_line(i, side2lett, num2side, easyd))
        tot += array2number([word2number(word, rosetta, num2side) for word in split(i[2], " ")])
    end
    tot
end

println("Part 2: ", solve(input))
