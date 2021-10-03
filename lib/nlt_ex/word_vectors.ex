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

  def vectorize_tokens(tokens, %__MODULE__{} = wv) do
    zeros = Nx.broadcast(0, wv.shape)
    tokens
    |> Enum.map(fn t -> Map.get(wv.wordvecs, t, zeros) end)
  end

  def put(wv, word, vec) do
    vshape = Nx.shape(vec)
    unless vshape == wv.shape do
      raise ArgumentError,
      "expected input shape to match vector definitions," <>
        " got #{inspect(vshape)} != #{inspect(wv.shape)}"
    end
    %{wv | wordvecs: Map.put(wv.wordvecs, word, vec)}
  end

  def get(wv, word) do
    get(wv, word, Nx.broadcast(0.0, wv.shape))
  end

  def get(wv, word, defval) do
    Map.get(wv.wordvecs, word, defval)
  end

end
