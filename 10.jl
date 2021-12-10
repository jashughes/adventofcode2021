input = split.(readlines("10.txt"), "")

op = Dict("(" => ")", "[" => "]", "{" => "}", "<" => ">")
prices1 = Dict(")" => 3, "]" => 57, "}" => 1197, ">" => 25137)
prices2 = Dict("(" => 1, "[" => 2, "{" => 3, "<" => 4)
halfway(arr) = arr[Int(ceil(length(arr)/2))]

function cost_of_corruption(str, op = op, p1 = prices1, p2 = prices2)
    brackets = []
    for s in str
        if s in keys(op)
            push!(brackets, s)
        elseif s == op[brackets[end]]
            pop!(brackets)
        else
            return [true, p1[s]]
        end
    end
    [false, reduce((a,b) -> a * 5 + p2[b], reverse(brackets), init = 0)]
end

costs = [cost_of_corruption(s) for s in input]

println("Part 1: ", sum(filter(x -> x[1] == 1, costs))[2])
println("Part 2: ", halfway(sort(filter(x -> x[1] == 0, costs)))[2])