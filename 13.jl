# Read input, store as matrix of dots (values > 0)
using SparseArrays
dots, folds = split.(split(read("13.txt", String), "\n\n"), "\n")
dots = [parse.(Int, x) .+ 1 for x in split.(dots, ",")]
sheet = sparse(last.(dots), first.(dots), true)

foldline(instr) = parse(Int, match(r"([0-9]+)", instr)[1])
fold(a, l, x) = x ? a[:,1:l] + a[:,end:-1:l+2] : a[1:l,:] + a[end:-1:l+2,:]

function origami(sheet, folds)
    for f in folds
        sheet = fold(sheet, foldline(f), contains(f, r"x="))
    end
    sheet
end

println("Part 1: ", sum(origami(sheet, [folds[1]]) .> 0))
println("Part 2:")
display(origami(sheet, folds))