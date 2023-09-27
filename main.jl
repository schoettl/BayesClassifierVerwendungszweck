import Pkg;
Pkg.activate(@__DIR__)

include("src/dataloading.jl")
include("src/tokenize.jl")
include("src/model.jl")

data = load_data("ledger.csv")

train_data, test_data = split_train_test(data)

m = NaiveBayesClassifier(unique(data.account))

println("Before training:")
test_model(m, train_data)

train!(m, train_data)
boost!(m, train_data)

println("After training on training data:")
test_model(m, train_data)

println("Test data:")
test_model(m, test_data, 0.9)

## Accuracy on Training Data


# test_text = "Das ist Beispiel: Fahrtkosten München -Hamburg 20Euro 20€ eur euros, München-Berlin"
# tokens = tokenize_verwendungszweck(text)

# ## Test Model
# using TextAnalysis

# accounts = ["account1", "girokonto", "tagesgeld", "expenses"]
# m = NaiveBayesClassifier(accounts)

# for (t, acc) in [test_text => "account1"]
#     fit!(m, t, acc)
# end

# predict(m, test_text)

