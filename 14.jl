tmpl, insrts = split.(split(read("14.txt", String), "\n\n"), "\n")

d = Dict(k => v for (k,v) in split.(insrts, " -> "))
p = Dict(k => [k[1] * v, v * k[2]] for (k, v) in d)
max_minus_min(arr) = maximum(arr) - minimum(arr)

function pairplicate(p, pairs, tallies)
    stoichiometry = [[p[i], get(tallies, i, 1)] for i in pairs]
    nt = Dict()
    for (st, n) in stoichiometry
        nt[st[1]] = get(nt, st[1], 0) + 1 * n
        nt[st[2]] = get(nt, st[2], 0) + 1 * n
    end
    nt
end

function tally2freq(tallies, str)
    freq = Dict()
    for k in keys(tallies)
        freq[k[1]] = get(freq, k[1], 0) + tallies[k]
    end
    freq[str[end]] = get(freq, str[end], 0) + 1
    freq
end

function polyshort(str, p, N)
    pairs = [str[i:i+1] for i = 1:length(str)-1]
    tallies = Dict()
    for _ = 1:N
        tallies = pairplicate(p, pairs, tallies)
        pairs = keys(tallies)
    end
    tally2freq(tallies, str)
end

println("Part 1: ", max_minus_min(values(polyshort(tmpl[1], p, 10))))
println("Part 2: ", max_minus_min(values(polyshort(tmpl[1], p, 40))))