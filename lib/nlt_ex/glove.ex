defmodule NLTEx.GloVe do
  @moduledoc """
  Provides interface to retrieve and consistently structure GloVe word vectors
  """

  @base_url               "http://localhost:8080/" #TODO "http://nlp.stanford.edu/data/"
  @file_glove_6b          "glove.6B.zip"
  # @file_glove_42b         "glove.42B.300d.zip"
  # @file_glove_840b        "glove.840B.300d.zip"
  @file_glove_twitter_27b "glove.twitter.27B.zip"
  @glove_vecs %{
    {:glove_6b, :d50} => {@file_glove_6b, 'glove.6B.50d.txt'},
    {:glove_6b, :d100} => {@file_glove_6b, 'glove.6B.100d.txt'},
    {:glove_6b, :d200} => {@file_glove_6b, 'glove.6B.200d.txt'},
    {:glove_6b, :d300} => {@file_glove_6b, 'glove.6B.300d.txt'},

    # TODO getting {:error, :badmatch} on unzip # {:glove_42b, :d300} => {@file_glove_42b, 'glove.42B.300d.txt'},

    # TODO getting {:error, :badmatch} on unzip # {:glove_840b, :d300} => {@file_glove_840b, 'glove.840B.300d.txt'},

    {:glove_twitter_27b, :d25} => {@file_glove_twitter_27b, 'glove.twitter.27B.25d.txt'},
    {:glove_twitter_27b, :d50} => {@file_glove_twitter_27b, 'glove.twitter.27B.50d.txt'},
    {:glove_twitter_27b, :d100} => {@file_glove_twitter_27b, 'glove.twitter.27B.100d.txt'},
    {:glove_twitter_27b, :d200} => {@file_glove_twitter_27b, 'glove.twitter.27B.200d.txt'},
  }

  alias Scidata.Utils

  @doc """
  Download and unpack the requested GloVe vector file and parse into %NLTEx.WordsVecs{}
  """
  def download(lib, vec) do
    {lib_file, vec_file} = Map.get(@glove_vecs, {lib, vec})

    {words, vecs} = Utils.get!(@base_url <> lib_file).body
    |> extract_vec_data(vec_file)
    |> process_vec_data()

    NLTEx.WordsVecs.new(words, vecs)
  end

  # Util function to handle extracting specific file from ZIPfile
  defp extract_vec_data(zipdata, vec_file) do
    {:ok, files} = :zip.unzip(zipdata, [:memory, {:file_list, [vec_file]}])
    files
    |> hd()
    |> elem(1)
  end

  # Util function to process raw data from ZIPfile into {words, vecs}
  defp process_vec_data(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split/1)
    |> Enum.map(fn [word | vec] -> {word, (for x <- vec, do: elem(Float.parse(x), 0))} end)
    |> Enum.unzip()
  end

end
