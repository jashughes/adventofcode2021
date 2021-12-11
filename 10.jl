input = split.(readlines("10.txt"), "")

op = Dict("(" => ")", "[" => "]", "{" => "}", "<" => ">")
prices = Dict(")"=> 3,"]"=> 57,"}"=>1197,">"=>25137,"("=> 1,"["=>2,"{"=> 3,"<" =>4)

function cost_of_corruption(str, op = op, p = prices)
    brackets = []
    for s in str
        if s in keys(op)
            push!(brackets, s)
        elseif s == op[brackets[end]]
            pop!(brackets)
        else
            return [true, p[s]]
        end
    end
    [false, reduce((a,b) -> a * 5 + p[b], reverse(brackets), init = 0)]
end

costs = [cost_of_corruption(s) for s in input]

println("Part 1: ", sum(filter(x -> x[1] == 1, costs))[2])
println("Part 2: ", sort(filter(x -> x[1] == 0, costs))[end÷2 + 1][2])