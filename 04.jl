input = readlines("04.txt")
calls = split(input[1],",")
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

# part 1

function score_row(row, call)
    row[row .== call] .= "-0"
    row
end

function check_card(card)
    check_rows(card) | check_cols(card)
end

function check_rows(card)
    any([all(x .== "-0") for x in card])
end

function check_cols(card)
    for col = 1:length(card[1])
        if all(row[col] == "-0" for row in card) && return true end
    end
    false
end

function play_bingo(card_rows, calls)
    winner = 0
    for c in calls
        card_rows = [score_row(cr, c) for cr in card_rows]
        for i = 1:5:(length(card_rows) - 4)
            if check_card(card_rows[i:i+4])
                winner = sum(sum(parse.(Int, c) for c in card_rows[i:i+4])) * parse(Int, c)
                break
            end
        end
        if winner > 0 
            break 
        end
    end
    winner 
end

function lose_bingo(card_rows, calls)
    scores, winner = zeros(100), 0
    for c in calls
        card_rows = [score_row(cr, c) for cr in card_rows]
        for i = 1:5:(length(card_rows) - 4)
            idx = Int(ceil(i/5))
            if check_card(card_rows[i:i+4]) & (scores[idx] == 0)
                scores[idx] = sum(sum(parse.(Int, c) for c in card_rows[i:i+4])) * parse(Int, c)
                winner = scores[idx]
            end
        end
    end
    winner
end

println("Part 1: ", play_bingo(deepcopy(card_rows), calls))
println("Part 2: ", lose_bingo(deepcopy(card_rows), calls))