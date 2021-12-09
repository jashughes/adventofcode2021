input = hcat([parse.(Int, s) for s in split.(readlines("09.txt"), "")]...)


function idx(i, j, n = 100)
    dirs = [(i, j) .+ d for d in [(-1, 0), (1, 0), (0, 1), (0, -1)]] 
    filter(x -> (0 < x[1] <= n) && (0 < x[2] <= n), dirs)
end

function find_mins(input)
    mins = 0
    for i = 1:100
        for j = 1:100
            neighbours = [input[p...] for p in idx(i, j)]
            if all(input[i, j] .< neighbours)
                mins += input[i,j] + 1
            end
        end
    end
    mins
end

println("Part 1: ", find_mins(input))

function find_min_locations(input)
    mins = []
    for i = 1:100
        for j = 1:100
            neighbours = [input[p...] for p in idx(i, j)]
            if all(input[i, j] .< neighbours)
                push!(mins, (i, j))
            end
        end
    end
    mins
end

grow_basin(m, nines) = filter(x -> nines[x...], idx(m[1], m[2]))

function find_basins(input)
    mins = find_min_locations(input)
    nines = input .!= 9
    basin_dims = []
    for m in mins
        basin = Set([m])
        add_to_basin = [m]
        while length(add_to_basin) > 0
            push!(basin, add_to_basin...)
            neighbours = Set()
            for b in add_to_basin
                push!(neighbours, grow_basin(b, nines)...)
            end
            add_to_basin = setdiff(neighbours, basin)
        end
        push!(basin_dims, length(basin))
    end
    basin_dims
end

println("Part 2: ", prod(sort(find_basins(input), rev = true)[1:3]))

#1269555