defmodule NLTEx.Tokenizer.Simple do
  @moduledoc ~S"""
  Simple tokenizer that splits on whitespace and punctuation
  """

  def transform(doc) do
    doc
    |> String.split(~R/\W/, trim: true)
  end
end
