defmodule NLTEx.Tokenizer.Simple do
  @moduledoc ~S"""
  Simple tokenizer that splits on whitespace and punctuation
  """

  def tokenize(doc) do
    doc
    |> String.split(~R/\W/, trim: true)
  end
end
