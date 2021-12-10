input = split.(readlines("10.txt"), "")

op = Dict("(" => ")", "[" => "]", "{" => "}", "<" => ">")


function find_corruption(str, op = op)
    brackets = []
    for s in str
        if s in keys(op)
            push!(brackets, s)
        elseif s == op[brackets[end]]
            pop!(brackets)
        else
            return s
        end
    end
end

costs = Dict(")" => 3, "]" => 57, "}" => 1197, ">" => 25137)
println("Part 1: ", sum(costs[c] for c in filter(!isnothing, [find_corruption(s) for s in input])))

function is_corrupt(str, op = op)
    brackets = []
    for s in str
        if s in keys(op)
            push!(brackets, s)
        elseif s == op[brackets[end]]
            pop!(brackets)
        else
            return true
        end
    end
    false
end

incomplete = filter(!is_corrupt, [i for i in input])

function complete(str, op = op)
    brackets = []
    for s in str
        if s in keys(op)
            push!(brackets, s)
        elseif s == op[brackets[end]]
            pop!(brackets)
        end
    end
    [op[x] for x in reverse(brackets)]
end

tidy = [complete(i) for i in incomplete]


function cost(arr, tab = Dict(")" => 1, "]" => 2, "}" => 3, ">" => 4))
    score = 0
    for a in arr
        score = (score * 5) + tab[a]
    end
    score
end

println("Part 2: ", sort([cost(t) for t in tidy])[Int(ceil(length(tidy)/2))])
