defmodule NLTEx.Vocabulary do
  @moduledoc ~S"""
  Tools for creating and manipulating vocabularies
  """

  def transform(docs, opts \\ []) when is_list(docs) do
    tokenizer = opts[:tokenizer] || &NLTEx.Tokenizer.Simple.transform/1
    case_handler = opts[:case_handler] || &String.downcase/1
    stemmer = opts[:stemmer] || &NLTEx.Stemmer.Porter.transform/1

    docs
    |> Stream.flat_map(tokenizer)
    |> MapSet.new() # Reduce set to unique raw tokens at this point for perf
    |> Task.async_stream(fn token ->
      token
      |> stemmer.()
      |> case_handler.()
      end, timeout: :infinity)
    |> Enum.map(fn x -> elem(x, 1) end)
    |> MapSet.new() # Reduce to unique tokens, post-processing
    |> Enum.with_index()
    |> Map.new()
  end

end
