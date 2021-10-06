defmodule NLTEx.Stemmer.Porter.Test do
  use ExUnit.Case
  doctest NLTEx.Stemmer.Porter

  @test_data_file "./test/stemmer/porter_test_data.csv"

  test "sanity" do
    assert(true)
    file = File.open!(@test_data_file, [:read])
    process_file(file)
  end

  defp process_file(file) do
    row = IO.read(file, :line)

    if (row != :eof) do
      [word1, word2] = handle_row(row)
      assert(NLTEx.Stemmer.Porter.stem(word1) =~ word2)
      process_file(file)
    end
  end

  defp handle_row(row) do
    Regex.split(~r/,/, String.trim(row))
  end
end
