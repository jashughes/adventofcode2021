using LinearAlgebra
st2ints(s) = [parse(Int, s[f]) for f in findall(r"(-*[0-9]+)", s)] 
add_scanner!(d, i) = d[match(r"([0-9]+)", i[1])[1]] = [st2ints(x) for x in i[2:end]]
manhattan(a1, a2) = sum(abs.(a1-a2))

input = split.(split(read("19.txt", String), "\n\n"), "\n")
d = Dict()
for i in input add_scanner!(d, i) end

function rotmat() 
    ts = []
    for i in [-1, 1]
        for j in [-1, 1]
            for k in [-1, 1]
                push!(ts,  [i 0 0; 0  j  0; 0 0 k])
                push!(ts,  [0 i 0; j  0  0; 0 0 k])
                push!(ts,  [0 0 i; 0  j  0; k 0 0])
                push!(ts,  [0 i 0; 0  0  j; k 0 0])
                push!(ts,  [i 0 0; 0  0  j; 0 k 0])
                push!(ts,  [0 0 i; j  0  0; 0 k 0])
            end
        end
    end
    filter(t -> cross(t[1,:], t[2,:]) == t[3,:], ts)
end

function offset(scanner1, scanner2)
    offs = Dict()
    for s1 in scanner1
        for s2 in scanner2
            dx = s1 - s2
            offs[dx] = (get(offs, dx, 0)[1] + 1, [s1, s2])
        end
    end
    offs
end

function find_beacons(s1, rs2, dx)
    beacons = Dict()
    for b1 in s1
        for b2 in rs2
            if b1 - b2 == dx
                beacons[b1] = b2
            end
        end
    end
    beacons
end

function pinpoint_scanner(scanner1, scanner2, ts)
    for t in ts
        rs2 = [t * v  for v in scanner2]
        offs = offset(scanner1, rs2)
        
        if maximum(offs[k][1] for k in keys(offs)) >=12
            dx = pop!(filter(k -> offs[k][1] >= 12, keys(offs)))
            p1, p1prime = offs[dx][2]
            beacons = find_beacons(scanner1, rs2, dx)
            return p1, p1prime, beacons
        end
    end
    [], [], Dict()
end

function align_scanner(scanner1, scanner2, ts)
    for t in ts
        rs2 = [t * v  for v in scanner2]
        offs = offset(scanner1, rs2)
        
        if maximum(offs[k][1] for k in keys(offs)) >=12
            dx = pop!(filter(k -> offs[k][1] >= 12, keys(offs)))
            return dx, [r + dx for r in rs2]
        end
    end
    [], []
end

function beckon_beacons(d, n = 12)
    scanners = sort([k for k in keys(d)])
    sloc = Dict(scanners[1] => [0, 0, 0])
    beacons = Set()
    ts = rotmat()
    while length(keys(sloc)) != length(scanners)
        for s1 in scanners
            if !(s1 in keys(sloc)) continue end
            for s2 in scanners
                if s1 == s2 continue end
                dx, new_s2 = align_scanner(d[s1], d[s2], ts)
                if length(new_s2) == 0 continue end #no overlap
                d[s2] = new_s2
                if !(s2 in keys(sloc)) sloc[s2] = dx end
            end
        end
    end

    for k in keys(d)
        push!(beacons, d[k]...)
    end
    beacons, sloc
end

function manhattanpairwise(arr)
    ds = []
    for a1 in arr
        for a2 in arr
            if a1 == a2 continue end
            push!(ds, manhattan(a1, a2))
        end
    end
    maximum(ds)
end

d = Dict()
for i in input add_scanner!(d, i) end
beacons, sloc = beckon_beacons(d)
println("Part 1: ", length(beacons))
println("Part 2: ", manhattanpairwise(values(sloc)))
