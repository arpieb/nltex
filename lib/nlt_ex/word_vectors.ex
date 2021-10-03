defmodule NLTEx.WordVectors do
  @moduledoc ~S"""
  Provides a consistent structure for any word vector representation to be
  mapped into for general consumption.
  """

  @enforce_keys [:wordvecs, :shape]
  defstruct [:wordvecs, :shape]

  def new(wordvecs, shape) do
    %__MODULE__{
      wordvecs: wordvecs,
      shape: shape
    }
  end

  @doc ~S"""
  Vectorize a list of tokens into a list of n-dimensional vectors using the provided word vector mappings
  """
  def vectorize_tokens(tokens, %__MODULE__{} = wv) do
    zeros = Nx.broadcast(0, wv.shape)
    tokens
    |> Enum.map(fn t -> Map.get(wv.wordvecs, t, zeros) end)
  end

end
