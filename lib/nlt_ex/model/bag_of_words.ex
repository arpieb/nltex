defmodule NLTEx.Model.BagOfWords do
  @moduledoc ~S"""
  Provides functions of generating Bag of Words representation of text given a vocabulary
  """

  @default_defn_compiler EXLA

  import Nx.Defn

  def transform(docs, vocab, opts \\ []) do
    tokenizer = opts[:tokenizer] || &NLTEx.Tokenizer.Simple.transform/1
    case_handler = opts[:case_handler] || &String.downcase/1
    stemmer = opts[:stemmer] || &NLTEx.Stemmer.Porter.transform/1

    iotas = Nx.iota({length(Map.keys(vocab))})

    docs
    |> Stream.map(tokenizer)
    |> Stream.map(fn tokens -> to_bow_one(tokens, vocab, iotas, stemmer, case_handler) end)
    |> Enum.to_list()
    |> Nx.stack()
  end

  defp to_bow_one(tokens, vocab, iotas, stemmer, case_handler) do
    tokens
    |> Stream.map(stemmer)
    |> Stream.map(case_handler)
    |> Stream.map(fn token -> Map.get(vocab, token, -1) end)
    |> Enum.to_list()
    |> Nx.tensor(type: {:f, 32})
    |> nx_bow_proc(iotas)
  end

  defnp nx_bow_proc(t, iotas) do
    t
    |> Nx.new_axis(-1)
    |> Nx.equal(iotas)
    |> Nx.sum(axes: [0])
  end

end
