# BayesClassifierVerwendungszweck.jl

Tokenizer and Naive Bayes classifier for hledger CSV output using
Verwendungszweck and amount

Here is an example script that uses this library to assign the
accounts in stdin and writing the result to stdout.
The first argument `ledger.csv` is used as training data.

```sh
time julia --project=. run.jl ledger.csv < ledger2023.csv > ledger2023-assigned.csv
```

Fragen:

- wie installiert man alle deps von project.toml?
- how to run a julia script on command line?
- wann === und !== ?
- tryparse -> UndefVarError `warn` not defined
- ! required in assign_accounts! when second arg is modified?
- "show" bzw. tostring definieren für Amount typ
- vorzeichen von amount als token einbeziehen
- `load_data` soll nicht nur string (filename) sondern auch stdin stream können
- how to print warnings to stderr?
