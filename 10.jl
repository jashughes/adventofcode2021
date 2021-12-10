input = split.(readlines("10.txt"), "")

op = Dict("(" => ")", "[" => "]", "{" => "}", "<" => ">")
prices1 = Dict(")" => 3, "]" => 57, "}" => 1197, ">" => 25137)
prices2 = Dict(")" => 1, "]" => 2, "}" => 3, ">" => 4)

function cost(arr, tab = prices2)
    score = 0
    for a in arr
        score = (score * 5) + tab[a]
    end
    score
end

function cost_of_corruption(str, op = op)
    brackets = []
    for s in str
        if s in keys(op)
            push!(brackets, s)
        elseif s == op[brackets[end]]
            pop!(brackets)
        else
            return [true, prices1[s]]
        end
    end
    [false, cost([op[x] for x in reverse(brackets)])]
end

costs = [cost_of_corruption(s) for s in input]
uncorrupted = sort(filter(x -> x[1] == 0, costs))

println("Part 1: ", sum(filter(x -> x[1] == 1, costs))[2])
println("Part 2: ", uncorrupted[Int(ceil(length(uncorrupted)/2))][2])
