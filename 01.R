# read & parse input
input <- as.numeric(readLines("01.txt", warn = FALSE))

# part 1
print(paste0(
  "Part 1: ", 
  sum(diff(input) > 0)
))

# part 2
print(paste0(
  "Part 2: ", 
  sum(diff(input, lag = 3) > 0)
))
