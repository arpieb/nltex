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
  """
  def vectorize_tokens(tokens, %__MODULE__{} = wv) do
    vectors = wv.vectors
    words = wv.words

    tokens
    |> Enum.filter(fn t -> Map.has_key?(words, t) end)
    |> Enum.map(fn t -> vectors[Map.get(words, t)] end)
  end
end
