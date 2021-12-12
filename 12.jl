using MetaGraphs
using LightGraphs
# read in input, identify unique rooms
room_set = Set()
input = split.(readlines("12.txt"), "-")
for l in input push!(room_set, l[1], l[2]) end

# dictionary of key to indices/indices to keys
inv_dict(r) = Dict(r[k] => k for k in keys(r))
rooms = Dict(k => v for (k,v) in zip(room_set, 1:length(room_set)))
idx = inv_dict(rooms)

# create a graph
add_room!(g, r1, r2, rooms) = add_edge!(g, rooms[r1], rooms[r2])
g = Graph(length(room_set))
for l in input add_room!(g, l[1], l[2], rooms) end


# Functions
function is_invalid(path, idx, max)
    rn = path[end]
    idx[rn] == "start" && return true
    idx[rn] == "end" && return false
    uppercase(idx[rn]) == idx[rn] && return false
    
    lowers = filter(x -> lowercase(x) == x, [idx[p] for p in path])
    (length(lowers) - length(unique(lowers))) > max
end

function find_paths(g, path, idx, max)
    neighbours = outneighbors(g, path[end])
    paths_out = []
    for rn in neighbours
        new_path = deepcopy(path)
        append!(new_path, rn)
        if is_invalid(new_path, idx, max) continue end
        push!(paths_out, new_path)
    end
    paths_out
end


function finish_paths(g, rooms, idx, max)
    unfinished = [[rooms["start"]]]
    finished = []
    while length(unfinished) > 0
        new = []
        [[push!(new, p) for p in find_paths(g, u, idx, max)] for u in unfinished]
        [push!(finished, f) for f in filter(x -> x[end] == rooms["end"], new)]
        unfinished = filter(x -> x[end] != rooms["end"], new)
    end
    finished
end

println("Part 1: ", length(finish_paths(g, rooms, idx, 0)))
println("Part 2: ", length(finish_paths(g, rooms, idx, 1)))