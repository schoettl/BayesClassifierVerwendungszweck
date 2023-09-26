#!/usr/bin/env julia

include("src/dataloading.jl")
include("src/tokenize.jl")
include("src/model.jl")

if length(ARGS) !== 1
    error("missing argument: first command line argument must be CSV filename.")
end

training_data = load_data(ARGS[1])
m = NaiveBayesClassifier(unique(training_data.account))
train!(m, training_data)

data = load_data(stdin)

assign_accounts!(m, data)

CSV.write(stdout, data)

# println("Accuracy with real data: $(test_model(m, data))")

# TODO print to stderr the number of accounts that are still TODO
undecided = filter(data, data.account === "TODO") |> nrow
# println("number of undecided rows: $undecided")
