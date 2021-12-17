string2ints(s) = [parse(Int, s[f]) for f in findall(r"(-*[0-9]+)", s)] 
step(p, v) = p .+ v, (v[1] -sign(v[1]), v[2] - 1)
x1,x2,y1,y2 = string2ints(read("17.txt", String))

function solve(x1, x2, y1, y2)
    valid = Set()
    for x = 1:x2
        for y = y1:abs(y1)
            checkvalid!(valid, (x,y), x1, x2, y1, y2)
        end
    end
    length(valid)
end

function checkvalid!(valid, start, x1, x2, y1, y2)
    p, v = (0, 0), start
    while p[2] ≥ y1 && p[1] ≤ x2
        p, v = step(p,v)
        if (x1 ≤ p[1] ≤ x2) && (y1 ≤ p[2] ≤ y2)
            push!(valid, start)
            break
        end
    end
end

function fly_high(v)
    p, ymax = (0, 0), 0
    while p[2] ≥ 0
        p, v = step(p,v)
        ymax = maximum([p[2], ymax])
    end
    ymax
end

# For part 1, highest y happens when you start with y = y1-1
# The x coordinate doesn't matter (use 1 as a place holder)
println("Part 1: ", fly_high((1, abs(y1 + 1))))
println("Part 2: ", solve(x1, x2, y1, y2))