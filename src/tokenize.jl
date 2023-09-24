using WordTokenizers

regexmatch(r) = s -> match(r, s) |> !isnothing

regexremove(r) = tokens -> map(s -> replace(s, r => ""), tokens)

f = s -> replace(s, r"^[-_.:]+" => "", r"[-_.:]+$" => "")

function add_adjacent_merged_words(tokens)
    last = nothing
    temp = copy(tokens)
    for t in temp
        if !isnothing(last)
            push!(tokens, last * t)
        end
        last = t
    end
    return tokens
end

# TODO compare different tokenizer post processing steps
function tokenize_verwendungszweck(text)
    penn_tokenize(text) .|> lowercase |>
        filter(x -> length(x) > 1) |>
        filter(!regexmatch(r"^\d+$")) |>
        filter(!regexmatch(r"^euro?$")) |>
        regexremove(r"^[-_.:]+") |>
        regexremove(r"[-_.:]+$") |>
        tokens -> vcat(split.(tokens, '-')...) |>
        add_adjacent_merged_words
end
