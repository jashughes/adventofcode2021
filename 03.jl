input = hcat([parse.(Int, split(i, "")) for i in readlines("03.txt")]...)

function count_pos(a)
    [sum(x) for x in eachrow(hcat(a...))]
end

function scan_array(a, i, f)
    counts = count_pos(a)
    ci = Int(f(counts[i], length(a)/2))
    filter(x -> x[i] == ci, a)
end

# part 1
array_to_binary(a) = parse(Int, join(a, ""), base = 2)
gamma  = array_to_binary(Int.(sum(input, dims = 2) .> size(input, 2)/2))
epsilon = array_to_binary(Int.(sum(input, dims = 2) .< size(input, 2)/2))

# part 2
function solve(input)
    o2, co2 = input, input
    for i = 1:length(input[1])
        if length(o2) > 1
            o2 = scan_array(o2, i, >=)
        end
        if length(co2) > 1
            co2 = scan_array(co2, i, <)
        end
    end
    o2[1], co2[1]
end

o2, co2 = solve(input)

println("Part 1: ", gamma * epsilon)
println("Part 2: ", array_to_binary(o2) * array_to_binary(co2))