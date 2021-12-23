st2ints(s) = [parse(Int, s[f]) for f in findall(r"(-*[0-9]+)", s)] 
UniqSpts(arr, r) = sort(unique(vcat([x[2][r] for x in arr]...)))
tuplein(t1, t2) = (t1[1] >= t2[1] && t1[2] <= t2[2])
vol(t1,t2,t3) = (t1[2] - t1[1] + 1) * (t2[2] - t2[1] + 1) * (t3[2] - t3[1] + 1) 
tupled(arr) = [(arr[1], arr[2]), (arr[3], arr[4]), (arr[5], arr[6])]

input = [(match(r"([a-z]+) ", s)[1], st2ints(s)) for s in readlines("22.txt")]

# Part 1
function flicker(input)
    mn = minimum([minimum(i[2]) for i in input])
    mx = maximum([maximum(i[2]) for i in input]) + 1
    d = (mx-mn)
    m = zeros(Int64, d, d, d)

    for i in input
        instr, p = i[1], i[2] .+ mx
        if instr == "on"
            m[p[1]:p[2], p[3]:p[4], p[5]:p[6]] .= 1
        else
            m[p[1]:p[2], p[3]:p[4], p[5]:p[6]] .= 0
        end
    end
    sum(m)
end

# Part 2
function chunk(input)
    xs, ys, zs = UniqSpts(input, 1:2), UniqSpts(input, 3:4), UniqSpts(input, 5:6)
    append!(xs, xs .+ 1), append!(ys, ys .+ 1), append!(zs, zs .+ 1)
    xs, ys, zs = sort(xs), sort(ys), sort(zs)
    tot = 0
    
    for xi = 2:length(xs)
        println(xi)
        x1,x2 = xs[xi-1:xi] .+ [0, -1]
        for yi = 2:length(ys)
            y1,y2 = ys[yi-1:yi] .+ [0, -1]
            for zi = 2:length(zs)
                z1,z2 = zs[zi-1:zi] .+ [0, -1]
                pti = [(x1,x2),(y1,y2),(z1,z2)]
                reg = 0
                for i in input
                    instr, p = i[1], tupled(i[2])
                    if all([tuplein(t1,t2) for (t1, t2) in zip(pti, p)])
                        if instr == "on"
                            reg = 1
                        else
                            reg = 0
                        end
                    end
                end
                tot += reg * vol(pti...)
            end
        end
    end
    tot
end

println("Part 1: ", flicker(input[1:20]))
println("Part 2: ", chunk(input))
