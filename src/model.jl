using TextAnalysis

function train!(m::NaiveBayesClassifier, train::DataFrame)
    for row in eachrow(train)
        fit!(m, get_features(m, row), row.account)
    end
end

# boosting slighly increases accuracy, maybe try epochs as well
function boost!(m::NaiveBayesClassifier, train::DataFrame)
    for row in eachrow(train)
        prediction = predict(m, get_features(m, row))
        if find_most_probable(prediction) != row.account
            fit!(m, get_features(m, row), row.account)
        end
    end
end

# TODO return nothing if probability too low
find_most_probable(prediction) = findmax(last, prediction) |> last

function test_model(m, test, probability_threshold=0.8)
    correct = 0
    undecided = 0
    for row in eachrow(test)
        prediction = predict(m, get_features(m, row))
        probability, account = findmax(last, prediction)
        if probability > probability_threshold
            if find_most_probable(prediction) == row.account
                correct += 1
            end
        else
            undecided += 1
        end
    end
    total = nrow(test)
    wrong = total - correct - undecided
    @show correct / total
    @show undecided / total
    @show wrong / total
end

function assign_accounts!(m, data)
    for row in eachrow(data)
        prediction = predict(m, get_features(m, row))
        probability, account = findmax(last, prediction)
        if probability > 0.9
            row.account = account
        else
            row.account = "TODO"
        end
    end
end
