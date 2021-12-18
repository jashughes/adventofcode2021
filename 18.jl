string2ints(s) = [parse(Int, s[f]) for f in findall(r"(-*[0-9]+)", s)] 
input = readlines("18.txt")

function find_nested(str)
    stack = []
    for s = 1:length(str)
        if str[s] == '[' push!(stack, '[') end
        if str[s] == ']' pop!(stack) end
        if length(stack) == 5 
            return true, s
        end
    end
    false, length(str)
end

function find_big(str)
    ns = string2ints(str)
    if all(ns .< 10) return false, length(str) end
    ns = filter(>=(10), ns)[1]
    true, collect(findfirst("$ns", str))[1]
end

function explode(str)
    is_nest, ns = find_nested(str)
    if !is_nest return str end
    n = findfirst(r"\[[0-9]+\,[0-9]+\]", str[ns:end]) .+ ns .- 1
    expl = string2ints(str[n])
    lm = string2ints(str[1:n[1]])
    rm = string2ints(str[n[end]:end])
    if length(lm) > 0 
        lm = lm[end]
        lhs = str[1:n[1]-1]
        newlm = lm + expl[1]
        lmloc = findlast("$lm", lhs)
        lhs = lhs[1:lmloc[1]-1] * string(newlm) * lhs[lmloc[end]+1:end]
    else
        lhs = str[1:n[1]-1]
    end
    if length(rm) > 0
        rm = rm[1]
        rhs = str[n[end]+1:end]
        newrm = rm + expl[2]
        rmloc = findfirst("$rm", rhs)
        rhs = rhs[1:rmloc[1]-1] * string(newrm) * rhs[rmloc[end]+1:end]
    else
        rhs = str[n[end]+1:end]
    end
    lhs * "0" * rhs 
end

splat(s, f) = string(Int(f(parse(Int, s)/2)))

function splitit(str)
    needs_split, ns = find_big(str)
    if !needs_split return str end
    spl = str[ns:ns+1]
    newspl = "[" * splat(spl, floor) * "," * splat(spl, ceil) * "]"
    str[1:ns-1] * newspl * str[ns+2:end]
end

function plus(str1, str2)
    str = "[" * str1 * "," * str2 * "]"
    old, ex = "", ""
    while str != old
        old = str
        while str != ex
            ex = str
            str = explode(str)
        end
        str = splitit(str)
    end
    str
end

function snailfish(input)
    str = input[1]
    for i in input[2:end]
        str = plus(str, i)
    end
    magnitude(str)
end

function magnitude(str)
    while sum(s == "[" for s in split(str, "")) > 0
        str = repl_mag(str)
    end
    parse(Int, str)
end

function repl_mag(str)
    s1 = findfirst(r"\[[0-9]+\,[0-9]+\]", str)
    n = string2ints(str[s1])
    res = 3 * n[1] + 2 * n[2]
    str[1:s1[1]-1] * string(res) * str[s1[end]+1:end]
end

function find2(input)
    snailsums = []
    for i = 1:length(input)
        for j = 1:length(input)
            if i == j continue end
            str = plus(input[i], input[j])
            push!(snailsums, magnitude(str))
        end
    end
    maximum(snailsums)
end

println("Part 1: ", snailfish(input))
println("Part 2: ", find2(input))

# low budget unit tests

magnitude("[[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]") == 4140

explode("[[[[[9,8],1],2],3],4]") == "[[[[0,9],2],3],4]"
explode("[7,[6,[5,[4,[3,2]]]]]") == "[7,[6,[5,[7,0]]]]"
explode("[[6,[5,[4,[3,2]]]],1]") == "[[6,[5,[7,0]]],3]"
explode("[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]") == "[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]"
explode("[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]") == "[[3,[2,[8,0]]],[9,[5,[7,0]]]]"

splitit("[[[[0,7],4],[15,[0,13]]],[1,1]]") == "[[[[0,7],4],[[7,8],[0,13]]],[1,1]]"
splitit("[[[[0,7],4],[[7,8],[0,13]]],[1,1]]") == "[[[[0,7],4],[[7,8],[0,[6,7]]]],[1,1]]"