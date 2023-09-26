#!/usr/bin/env julia

# hässlich
import Pkg
Pkg.activate(@__DIR__)

# alternatively start with:
# julia --project=. run.jl

include("src/dataloading.jl")
include("src/tokenize.jl")
include("src/model.jl")

if length(ARGS) != 1
    error("missing argument: first command line argument must be CSV filename.")
end

training_data = load_data(first(ARGS))
m = NaiveBayesClassifier(unique(training_data.account))
train!(m, training_data)

data = load_data(stdin)

assign_accounts!(m, data)

CSV.write(stdout, data)

undecided = data[data.account .== "TODO", :] |> nrow
total = nrow(data)
println(stderr, "undecided rows: $undecided / $total")
