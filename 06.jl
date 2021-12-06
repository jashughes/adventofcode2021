# Read & parse input
input = parse.(Int, split(readlines("06.txt")[1], ","))

function counting_fish(input, days)
    ages = [length(input[input .== x]) for x in 0:8]
    for d = 1:days
        baby_fish = ages[1]
        ages = ages[2:end]
        push!(ages, baby_fish)
        ages[7] += baby_fish
    end
    sum(ages)
end

println("Part 1: ", counting_fish(input, 80))
println("Part 2: ", counting_fish(input, 256))
