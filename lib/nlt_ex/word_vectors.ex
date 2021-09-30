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
end
