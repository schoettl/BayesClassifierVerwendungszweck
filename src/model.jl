using TextAnalysis

function TextAnalysis.fit!(c::NaiveBayesClassifier, sd::AbstractVector, class)
    fs = TextAnalysis.frequencies(sd)
    for k in keys(fs)
        k in c.dict || TextAnalysis.extend!(c, k)
    end
    fit!(c, TextAnalysis.features(fs, c.dict), class)
end

function train!(m::NaiveBayesClassifier, train::DataFrame)
    for row in eachrow(train)
        fit!(m, tokenize_verwendungszweck(row.description), row.account)
    end
end

# boosting slighly increases accuracy, maybe try epochs as well
function boost!(m::NaiveBayesClassifier, train::DataFrame)
    for row in eachrow(train)
        prediction = predict(m, row.description)
        if find_most_probable(prediction) != row.account
            fit!(m, row.description, row.account)
        end
    end
end

# TODO return nothing if probability too low
find_most_probable(prediction) = findmax(last, prediction) |> last

function test_model(m, test)
    correct = 0
    for row in eachrow(test)
        prediction = predict(m, row.description)
        if find_most_probable(prediction) == row.account
            correct += 1
        end
    end
    return correct / nrow(test)
end

function assign_accounts!(m, data)
    for row in eachrow(data)
        prediction = predict(m, row.description)
        probability, account = findmax(last, prediction)
        if probability > 0.85
            row.account = account
        else
            row.account = "TODO"
        end
    end
end
