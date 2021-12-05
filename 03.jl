input = hcat([parse.(Int, split(i, "")) for i in readlines("03.txt")]...)

# part 1
array_to_binary(a) = parse(Int, join(a, ""), base = 2)
γε(i, f) = Int.(f(sum(i, dims = 2), size(i, 2)/2))

# part 2
scan_array(a, i, f) = a[:, a[i, :] .== Int(f(sum(a[i, :]), size(a, 2)/2))]
function solve(input)
    o2, co2 = input, input
    for i = 1:size(input, 1)
        if (size(o2, 2) > 1)  o2 = scan_array(deepcopy(o2), i, >=) end
        if (size(co2, 2) > 1) co2 = scan_array(deepcopy(co2), i, <) end
    end
    array_to_binary(o2) * array_to_binary(co2)
end

println("Part 1: ", array_to_binary(γε(input, .>)) * array_to_binary(γε(input, .<)))
println("Part 2: ", solve(input))