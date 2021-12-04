input = readlines("04.txt")
calls = split(input[1], ",")
card_rows = split.(
    replace.(
        replace.(
            filter(x -> length(x) > 0, input[3:end]), 
            r"( +)" => " "
        ),
        r"^ " => ""
    ), 
    " "
)

cards = [hcat(card_rows[i-4:i]...) for i = 5:5:length(card_rows)]

# part 1

function card_call(card, call)
    card[card .== call] .= "-0"
    card
end

function check_card(card)
    any(all(i -> i == ("-0"), card, dims = 1)) | any(all(i -> i == ("-0"), card, dims = 2))
end


function play_bingo(cards, calls)
    for c in calls 
        cards = [card_call(cr, c) for cr in cards]
        for card in cards
            if check_card(card)
                return sum(parse.(Int, card)) * parse(Int, c)
            end
        end
    end
end

function lose_bingo(cards, calls)
    scores, winner = zeros(length(cards)), 0
    for c in calls
        cards = [card_call(cr, c) for cr in cards]
        for i in 1:length(cards)
            if check_card(cards[i]) & (scores[i] == 0)
                scores[i] = sum(parse.(Int, cards[i])) * parse(Int, c)
                winner = scores[i]
            end
        end
    end
    Int(winner)
end

println("Part 1: ", play_bingo(deepcopy(cards), calls))
println("Part 2: ", lose_bingo(deepcopy(cards), calls))
