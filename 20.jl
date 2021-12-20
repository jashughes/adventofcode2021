recode(str, d = Dict("#" => 1, "." => 0)) = [d[s] for s in split(str, "")]
mat2bin(m) = parse(Int, join(vcat(m[:,1], m[:,2], m[:,3]), ""), base = 2)

enhance, img = split(read("20.txt", String), "\n\n")
img = hcat([recode(s) for s in split(img, "\n")]...)
enhance = recode(enhance)

function enhance_photo(enhance, img, n)
    # out matrix, needs to be 1 bigger than img in all 
    # directions add an extra border for indexing, but 
    # remove those squares before returning the output

    # My "enhance" sequence starts with a 1 and ends with 
    # a 0, which means that the "inifinity" value toggles 
    # between 1 and 0. 
    fpad, fout = mod(n,2) == 1 ? [zeros, ones] : [ones, zeros]
    dim = size(img) .+ 4
    
    padded = fpad(Int8, dim...)
    out = fout(Int8, dim...)
    padded[3:end-2,3:end-2] .= img

    for i = 2:size(padded)[1]-1
        for j = 2:size(padded)[2]-1
            d = mat2bin(padded[i-1:i+1,j-1:j+1])
            out[i, j] = enhance[d+1]
        end
    end
    out[2:end-1, 2:end-1]
end

function many_enhance(enhance, img, N)
    for n = 1:N
        img = enhance_photo(enhance, img, n)
    end
    sum(img)
end

println("Part 1: ", many_enhance(enhance, img, 2))
println("Part 2: ", many_enhance(enhance, img, 50))




