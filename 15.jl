using MetaGraphs, SimpleWeightedGraphs, Graphs
input = hcat([parse.(Int, s) for s in split.(readlines("15.txt"), "")]...)
CI = CartesianIndex

function idx(p, n)
    dirs = [(0,1), (0,-1), (1,0), (-1,0)]
    CI.(filter(x -> (0 < x[1] <= n[1]) && (0 < x[2] <= n[2]), [(p[1], p[2]) .+ d for d in dirs]))
end

function createGraph(input)
    mg = SimpleWeightedDiGraph(prod(size(input)))
    lu = Dict(ci => x for (ci, x) in zip(CartesianIndices(axes(input)), 1:prod(size(input))))
        
    for ci in CartesianIndices(axes(input))
        nb = idx(ci, size(input))
        for n in nb
            add_edge!(mg, lu[ci], lu[n], input[n])
        end
    end
    mg, lu, lu[CI((1,1))], lu[CI((size(input)...))]
end

path_weights(p, mg) = [get_weight(mg, p[i-1], p[i]) for i in 2:length(p)]

mg, lu, _start, _end = createGraph(input)
path = filter(x -> length(x) > 0 && x[end] == _end, enumerate_paths(dijkstra_shortest_paths(mg, _start)))[1]
println("Part 1: ", Int(sum(path_weights(path, mg))))

function cave_row(start_chamber, n)
    cave, new_chamber = deepcopy(start_chamber), deepcopy(start_chamber)
    for _ = 2:n
        new_chamber = deepcopy(new_chamber) .+ 1
        new_chamber[new_chamber .> 9] .= 1
        cave = hcat(cave, new_chamber)
    end
    cave
end

function bigger_cave(input, n = 5)
    big_cave = cave_row(input, n)
    seed_chamber = deepcopy(input)
    for _ = 2:n
        seed_chamber = deepcopy(seed_chamber) .+ 1
        seed_chamber[seed_chamber .> 9] .= 1
        new_row = cave_row(seed_chamber, n)
        big_cave = vcat(big_cave, new_row)
    end
    big_cave
end

big_cave = bigger_cave(input)
mg, lu, _start, _end = createGraph(big_cave)
path = filter(x -> length(x) > 0 && x[end] == _end, enumerate_paths(dijkstra_shortest_paths(mg, _start)))[1]
println("Part 2: ", Int(sum(path_weights(path, mg))))

# not 2185

