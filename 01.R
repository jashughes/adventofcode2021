# read & parse input
input <- as.numeric(readLines("01.txt", warn = FALSE))

# part 1
print(paste0(
  "Part 1: ", 
  sum(diff(input) > 0)
))

# part 2
N <- length(input)
print(paste0(
  "Part 2: ", 
  sum(diff(input[1:(N-2)] + input[2:(N-1)] + input[3:N]) > 0)
))
