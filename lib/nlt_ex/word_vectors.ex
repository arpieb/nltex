defmodule NLTEx.WordVectors do
  @enforce_keys [:words, :vectors]
  defstruct [:words, :vectors]

  def new(words, vectors) do
    %__MODULE__{
      words: words,
      vectors: vectors,
    }
  end
end
