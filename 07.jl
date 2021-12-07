# Read & parse input
using Statistics
input = parse.(Int, split(readlines("07.txt")[1], ","))

println("Part 1: ", Int(sum(abs.(input .- median(input)))))

println(
    "Part 2: ", 
    minimum(sum(sum.(range.(1, abs.(input .- m), step = 1)) for m = 1:length(input)))
)
