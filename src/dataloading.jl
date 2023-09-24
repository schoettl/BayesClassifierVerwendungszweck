using DataFrames, CSV, Random, Decimals

function load_data(file::String)
    types = [Int, String, String, String, String, Amount, Amount]
    data = CSV.File(file; types, strict=true) |> DataFrame
    return data
end

## Split in test and training data (maybe divide into old and new data)
function split_train_test(data::DataFrame)
    shuffled = shuffle(data)
    n = nrow(shuffled)
    train = shuffled[1:round(Int, n*0.8), :]
    test = shuffled[round(Int, n*0.8)+1:end, :]
    return train, test
end

## Amount Type
struct Amount
    amount::Float64
end

function Base.tryparse(::Type{Amount}, s::String)
    try
        amount, currency = split(s)
        if currency != "€"
            warn("Currency $currency not supported")
        end
        amount = replace(amount, ',' => '.')
        return Amount(parse(Decimal, amount))
    catch
        warn("Could not parse $s as Amount")
        return nothing
    end
end
