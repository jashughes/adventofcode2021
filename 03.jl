input = [parse.(Int, split(i, "")) for i in readlines("03.txt")]

# part 1
function count_pos(a)
    [sum(x) for x in eachrow(hcat(a...))]
end

function array_to_binary(a)
    parse(Int, join(a, ""), base = 2)
end

counts = count_pos(input)
gamma  = array_to_binary([(c >= 500) * 1 for c in counts])
epsilon = array_to_binary([(c < 500) * 1 for c in counts])

# part 2

o2 = deepcopy(input)
co2 = deepcopy(input)
for i = 1:length(counts)
    #ci = (counts[i] >= 500) * 1
    if length(o2) > 1
        counts_o2 = count_pos(o2)
        ci = (counts_o2[i] >= length(o2)/2) * 1
        o2 = [x for x in o2 if x[i] == ci]
    end
    if length(co2) > 1
        counts_co2 = count_pos(co2)
        ci = (counts_co2[i] >= length(co2)/2) * 1
        co2 = [x for x in co2 if x[i] != ci]
    end
end

println("Part 1: ", gamma * episilon)
println("Part 2: ", array_to_binary(o2...) * array_to_binary(co2...))