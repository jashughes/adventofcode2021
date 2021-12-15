using SimpleWeightedGraphs, Graphs
input = hcat([parse.(Int, s) for s in split.(readlines("15.txt"), "")]...)
CI = CartesianIndex

path_weights(p, mg) = [get_weight(mg, p[i-1], p[i]) for i in 2:length(p)]

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
    mg, lu[CI((1,1))], lu[CI((size(input)...))]
end

function bigger_cave(m)
    m = [
         m    m.+1 m.+2 m.+3 m.+4
         m.+1 m.+2 m.+3 m.+4 m.+5
         m.+2 m.+3 m.+4 m.+5 m.+6
         m.+3 m.+4 m.+5 m.+6 m.+7
         m.+4 m.+5 m.+6 m.+7 m.+8
        ]
    m .= mod1.(m, 9)
    m
end

function solve(input)
    mg, _s, _e = createGraph(input)
    path = filter(x -> length(x) > 0 && x[end] == _e, enumerate_paths(dijkstra_shortest_paths(mg, _s)))[1]
    Int(sum(path_weights(path, mg)))
end

println("Part 1: ", solve(input))
println("Part 2: ", solve(bigger_cave(input)))
