defmodule NLTEx.Vocabulary do
  @moduledoc ~S"""
  Tools for creating and manipulating vocabularies
  """

  @default_defn_compiler EXLA

  import Nx.Defn

  def from_text(docs, opts \\ []) when is_list(docs) do
    tokenizer = opts[:tokenizer] || &NLTEx.Tokenizer.Simple.tokenize/1
    case_handler = opts[:case_handler] || &String.downcase/1
    stemmer = opts[:stemmer] || &NLTEx.Stemmer.Porter.stem/1

    docs
    |> Stream.flat_map(tokenizer)
    |> Stream.map(stemmer)
    |> Stream.map(case_handler)
    |> MapSet.new()
    |> Enum.with_index()
    |> Map.new()
  end

  def to_bow(docs, vocab, opts \\ []) do
    tokenizer = opts[:tokenizer] || &NLTEx.Tokenizer.Simple.tokenize/1
    case_handler = opts[:case_handler] || &String.downcase/1
    stemmer = opts[:stemmer] || &NLTEx.Stemmer.Porter.stem/1

    iotas = Nx.iota({length(Map.keys(vocab))})

    docs
    |> Stream.map(tokenizer)
    |> Stream.map(fn tokens -> to_bow_one(tokens, vocab, iotas, stemmer, case_handler) end)
    |> Enum.to_list()
    |> Nx.stack()
  end

  defp to_bow_one(tokens, vocab, iotas, stemmer, case_handler) do
    tokens
    |> Enum.map(stemmer)
    |> Enum.map(case_handler)
    |> Enum.map(fn token -> Map.get(vocab, token, -1) end)
    |> Nx.tensor(type: {:f, 32})
    |> nx_bow_proc(iotas)
  end

  defnp nx_bow_proc(t, iotas) do
    t
    |> Nx.new_axis(-1)
    |> Nx.equal(iotas)
    |> Nx.sum(axes: [0])
  end

  def nop(doc), do: doc
end
