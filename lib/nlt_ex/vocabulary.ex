defmodule NLTEx.Vocabulary do
  @moduledoc ~S"""
  Tools for creating and manipulating vocabularies
  """

  @default_defn_compiler EXLA

  import Nx.Defn

  def from_text(docs, opts \\ []) when is_list(docs) do
    tokenizer = opts[:tokenizer] || (&nonword_tokenizer/1)
    case_handler = opts[:case_handler] || (&nop/1)

    docs
    |> Stream.map(case_handler)
    |> Stream.flat_map(tokenizer)
    |> MapSet.new()
    |> Enum.with_index()
    |> Map.new()
  end

  def to_bow(docs, vocab, opts \\ []) do
    tokenizer = opts[:tokenizer] || (&nonword_tokenizer/1)
    case_handler = opts[:case_handler] || (&nop/1)

    iotas = Nx.iota({length(Map.keys(vocab))})

    docs
    |> Stream.map(case_handler)
    |> Stream.map(tokenizer)
    |> Stream.map(fn tokens ->
      tokens
      |> Enum.map(fn token -> Map.get(vocab, token, -1) end)
      |> Nx.tensor(type: {:f, 32})
      |> nx_bow_proc(iotas)
    end)
    |> Enum.to_list()
    |> Nx.stack()
  end

  defn nx_bow_proc(t, iotas) do
    t
    |> Nx.new_axis(-1)
    |> Nx.equal(iotas)
    |> Nx.sum(axes: [0])
  end

  def nonword_tokenizer(doc) do
    doc
    |> String.split(~R/\W/, trim: true)
  end

  def nop(doc), do: doc
end
