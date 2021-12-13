using LightGraphs
# Utility Functions
inv_dict(r) = Dict(r[k] => k for k in keys(r))
islower(s) = all(islowercase(c) for c in s)
isupper(s) = all(isuppercase(c) for c in s)
add_room!(g, r1, r2, rooms) = add_edge!(g, rooms[r1], rooms[r2])

# read in input, identify unique rooms
room_set = Set()
input = split.(readlines("12.txt"), "-")
for l in input push!(room_set, l[1], l[2]) end

# dictionary of key to indices/indices to keys & room classifications
rooms = Dict(k => v for (k,v) in zip(room_set, 1:length(room_set)))
idx = inv_dict(rooms)

# create a graph
g = Graph(length(room_set))
for l in input add_room!(g, l[1], l[2], rooms) end

# Puzzle solving functions
function is_invalid(path, rn, idx, max)
    idx[rn] == "start" && return true
    idx[rn] == "end" && return false
    isupper(idx[rn]) && return false
    
    lowers = filter(islower, [idx[p] for p in vcat(path, rn)])
    (length(lowers) - length(unique(lowers))) > max
end

function find_paths(g, path, idx, max)
    neighbours = outneighbors(g, path[end])
    paths_out = []
    for rn in neighbours
        if is_invalid(path, rn, idx, max) continue end
        new_path = deepcopy(path)
        append!(new_path, rn)
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