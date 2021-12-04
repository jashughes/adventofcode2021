# Read & parse input
string2ints(s) = [parse(Int, s[f]) for f in findall(r"([0-9]+)", s)] 
rows2card(r) = Matrix{Union{Nothing, Int64}}(hcat(r...))

input = filter(x -> length(x) > 0, readlines("04.txt"))
calls = parse.(Int, split(input[1], ","))
card_rows = [string2ints(i) for i in input[2:end]]
cards = [rows2card(card_rows[i-4:i]) for i = 5:5:length(card_rows)]


function card_call(card, call)
    card[card .== call] .= nothing
    card
end

function has_bingo(card)
    any(all(isnothing, card, dims = 1)) | any(all(isnothing, card, dims = 2))
end

function bingo_scores(cards, calls)
    scores, winners = [], Set()
    for c in calls
        cards = [card_call(cr, c) for cr in cards]
        for i in 1:length(cards)
            if !(i in winners) && has_bingo(cards[i])
                push!(scores, c * sum(filter(!isnothing, cards[i])))
                push!(winners, i)
            end
        end
    end
    scores
end

scores = bingo_scores(cards, calls)

println("Part 1: ", scores[1])
println("Part 2: ", scores[end])
