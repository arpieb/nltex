defmodule NLTEx.WordsVecs do
  @enforce_keys [:words, :vecs]
  defstruct [:words, :vecs]

  def new(words, vecs) do
    %__MODULE__{
      words: words,
      vecs: vecs,
    }
  end
end
