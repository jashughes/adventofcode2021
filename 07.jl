# Read & parse input
using Statistics
input = parse.(Int, split(readlines("07.txt")[1], ","))

println("Part 1: ", Int(sum(abs.(input .- median(input)))))

function solve(input)
    min_move = Inf
    for m = 1:length(input)
        moves = sum(sum(1:abs(i - m)) for i in input)
        min_move  = Int(minimum([min_move, moves]))
    end
    min_move
end

println("Part 2: ", solve(input))