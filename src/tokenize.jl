using WordTokenizers
using UUIDs

const minus_uuid = uuid4() |> string
const plus_uuid = uuid4() |> string

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

function tokenize_amount(amount)
    # TODO maybe add tokens for bins?
    [ ifelse(amount.amount < 0, minus_uuid, plus_uuid) ]
end

function generate_tokens(row)
    vcat(tokenize_verwendungszweck(row.description), tokenize_amount(row.amount))
end

function get_features(m, row)
    tokens = generate_tokens(row)
    fs = TextAnalysis.frequencies(tokens)
    for k in keys(fs)
        k in m.dict || TextAnalysis.extend!(m, k)
    end
    TextAnalysis.features(fs, m.dict)
end
