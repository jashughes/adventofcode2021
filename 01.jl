input = parse.(Int, readlines("01.txt"))

println(
    "Part 1: ", 
    count(i -> i > 0, diff(input))
)
println(
    "Part 2: ",
    count(i -> i > 0, diff([sum(input[i:i+2]) for i in 1:length(input) - 3]))
)