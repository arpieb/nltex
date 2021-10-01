defmodule NLTEx.WordVectors do
  @moduledoc ~S"""
  Provides a consistent structure for any word vector representation to be
  mapped into for general consumption.
  """

  @enforce_keys [:words, :vectors]
  defstruct [:words, :vectors]

  def new(words, vectors) do
    %__MODULE__{
      words: words,
      vectors: vectors,
    }
  end

  @doc ~S"""
  Vectorize a list of tokens using the provided word vector mappings

  ## Examples

      iex> tokens = String.split("the fat cat")
      iex> {words, _} = tokens |> Enum.reduce({%{}, 0}, fn w, {v, i} -> {Map.put(v, w, i), i + 1} end)
      iex> vecs = Nx.eye(length(Map.keys(words)))
      iex> wv = NLTEx.WordVectors.new(words, vecs)
      iex> NLTEx.WordVectors.vectorize_tokens(tokens, wv)
  """
  def vectorize_tokens(tokens, %__MODULE__{} = wv) do
    vectors = wv.vectors
    words = wv.words

    tokens
    |> Enum.filter(fn t -> Map.has_key?(words, t) end)
    |> Enum.map(fn t -> vectors[Map.get(words, t)] end)
  end
end
