input = parse.(Int, readlines("01.txt"))

println(
    "Part 1: ", 
    sum(input[i] > input[i-1] for i in 2:length(input))
)
println(
    "Part 2: ",
    sum(sum(input[i+1:i+3]) > sum(input[i:i+2]) for i in 1:(length(input)-3))
)