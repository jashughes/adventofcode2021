# Read & parse input
string2ints(s) = [parse(Int, s[f]) for f in findall(r"([0-9]+)", s)] 
input = [string2ints(l) for l in readlines("05.txt")]

d = maximum(hcat(input...)) + 1
paths = zeros(Int8, d, d)

hv = filter(x -> x[1] == x[3] || x[2] == x[4], input)
diags = filter(x -> x[1] != x[3] && x[2] != x[4], input)

for i in hv
    xs, ys = sort([i[1], i[3]]), sort([i[2], i[4]])
    paths[xs[1]:xs[2], ys[1]:ys[2]] .+= 1
end

println("Part 1: ", length(filter(>=(2), paths)))

for i in diags
    xs = collect(range(i[1], i[3], step = sign(i[3]-i[1])))
    ys = collect(range(i[2], i[4], step = sign(i[4]-i[2])))
    for p in zip(xs, ys) paths[p...] += 1 end
end

println("Part 2: ", length(filter(>=(2), paths)))
