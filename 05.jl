# Read & parse input
string2ints(s) = [parse(Int, s[f]) for f in findall(r"([0-9]+)", s)] 
input = [string2ints(l) for l in readlines("05.txt")]

d = maximum(hcat(input...)) + 1

hv = filter(x -> x[1] == x[3] || x[2] == x[4], deepcopy(input))
diags = filter(x -> x[1] != x[3] && x[2] != x[4], deepcopy(input))

paths = zeros(Int8, d, d)
for i in hv
    xs = sort([i[1], i[3]]) .+ 1
    ys = sort([i[2], i[4]]) .+ 1
    paths[xs[1]:xs[2], ys[1]:ys[2]] .+= 1
end
length(filter(>=(2), paths))

println("Part 1: ", length(filter(>=(2), paths)))

for i in diags
    xs = collect(range(i[1], i[3], step = sign(i[3]-i[1]))) .+ 1
    ys = collect(range(i[2], i[4], step = sign(i[4]-i[2]))) .+ 1

    for n = 1:length(xs)
        paths[xs[n], ys[n]] += 1
    end
end

println("Part 1: ", length(filter(>=(2), paths)))
