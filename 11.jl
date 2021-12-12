input = Matrix{Union{Nothing, Int64}}(hcat([parse.(Int, s) for s in split.(readlines("11.txt"), "")]...))

function idx(p, n = 10)
    dirs = [(0,1), (0,-1), (1,0), (-1,0), (-1, -1), (1, 1), (-1, 1), (1, -1)]
    CartesianIndex.(filter(x -> (0 < x[1] <= n) && (0 < x[2] <= n), [(p[1], p[2]) .+ d for d in dirs]))
end

function flash!(input)
    dims, tot = size(input), 0
    for coor in CartesianIndices((1:dims[1], 1:dims[2]))
        if !isnothing(input[coor]) && input[coor] > 9
            tot += 1
            input[filter(x -> !isnothing(input[x]), idx(coor))] .+= 1
            input[coor] = nothing
        end
    end
    tot
end

function step(input)
    input .+= 1
    tot = 0
    while sum(input[input .!= nothing] .> 9) > 0
        tot += flash!(input)
    end
    input[input .== nothing] .= 0
    tot
end

function cycles(input, to_flash, n)
    tot, i = 0, 0
    while (!to_flash && i < n) || (to_flash && length(unique(input)) > 1)
        tot += step(input)
        i += 1
    end
    to_flash ? i : tot
end

println("Part 1: ", cycles(deepcopy(input), false, 100))
println("Part 2: ", cycles(deepcopy(input), true, 100))