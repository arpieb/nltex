defmodule NLTEx.Tokenizer.Simple.Test do
  use ExUnit.Case
  doctest NLTEx.Tokenizer.Simple

  test "ws test" do
    doc = "the fat cat sat"
    assert(["the", "fat", "cat", "sat"] = NLTEx.Tokenizer.Simple.transform(doc))
  end

  test "punc test" do
    doc = "the. fat! cat, sat'"
    assert(["the", "fat", "cat", "sat"] = NLTEx.Tokenizer.Simple.transform(doc))
  end

end
