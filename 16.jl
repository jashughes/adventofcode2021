input = read("16.txt", String)
h2bt = Dict(
    "0" => "0000",
    "1" => "0001",
    "2" => "0010",
    "3" => "0011",
    "4" => "0100",
    "5" => "0101",
    "6" => "0110",
    "7" => "0111",
    "8" => "1000",
    "9" => "1001",
    "A" => "1010",
    "B" => "1011",
    "C" => "1100",
    "D" => "1101",
    "E" => "1110",
    "F" => "1111"
)
bitstr2int(str) = parse(Int, str, base = 2)
hex2packet(str, d = h2bt) = join([d[s] for s in split(str, "")], "")

function parseLiteral(str)
    litval, start, x = "", '1', 1
    while start == '1'
        start = str[x]
        litval = litval * str[x+1:x+4]
        x += 5
    end
    bitstr2int(litval), x + 6
end

function readit(str)
    v = bitstr2int(str[1:3])
    tp = bitstr2int(str[4:6])
    if tp == 4
        lit, x = parseLiteral(str[7:end])
        return v, lit, x
    end 
    ltp = str[7]
    if ltp == '0'
        totlen = bitstr2int(str[8:22])
        x = 23 + totlen
        new_v, lit = parse2end(str[23:x-1])
        v += new_v
        return v, op(tp, lit), x
    end
    nsub = bitstr2int(str[8:18])
    lit, x = [], 19
    for _ = 1:nsub
        new_v, new_lit, new_x = readit(str[x:end])
        push!(lit, new_lit)
        v += new_v
        x += new_x -1
    end
    v, op(tp, lit), x
end

function parse2end(str)
    v, lit = 0, []
    while length(str) > 0
        new_v, new_lit, x = readit(str)
        str = str[x:end]
        v += new_v
        push!(lit, new_lit)
    end
    v, lit
end

function op(tp, lit) 
    tp == 4 && return lit
    tp == 0 && return sum(lit)
    tp == 1 && return prod(lit)
    tp == 2 && return minimum(lit)
    tp == 3 && return maximum(lit)
    tp == 5 && return Int(lit[1] > lit[2])
    tp == 6 && return Int(lit[1] < lit[2])
    tp == 7 && return Int(lit[1] == lit[2])
end

pt1, pt2, _ = readit(hex2packet(input))
println("Part 1: ", pt1, "\nPart 2: ", pt2)
