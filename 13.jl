# Read input, store as matrix of dots (values > 0)
input, div = readlines("13.txt"), 861
dots = [parse.(Int, x) .+ 1 for x in split.(input[1:div], ",")]
dotCI = [CartesianIndex((d...)) for d in dots]
folds = input[div + 2:end]
sheet = Matrix{Int64}(zeros(maximum(hcat(dots...), dims = 2)...))
sheet[dotCI] .= 1

foldline(instr) = parse(Int, match(r"([0-9]+)", instr)[1]) + 1
folddir(instr) = contains(instr, r"x=") ? 1 : 2

function fold(sheet, instr)
    l, d = foldline(instr), folddir(instr)
    if d == 1
        sheet[1:l-1,:] + reverse(sheet[l+1:end,:], dims = d)
    else
        sheet[:,1:l-1] + reverse(sheet[:,l+1:end], dims = d)
    end
end

function origami(sheet, folds)
    for f in folds
        sheet = fold(sheet, f)
    end
    sheet
end

function printmanual(manual)
    for j = 1:size(manual)[2]
        println(join(ifelse.(manual[:,j] .> 0, "#", " "), ""))
    end
end

println("Part 1: ", sum(fold(sheet, folds[1]) .> 0))
println("Part 2:")
printmanual(origami(sheet, folds))