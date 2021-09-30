defmodule NLTEx.WordVectors.GloVe do
  @moduledoc ~S"""
  Provides interface to retrieve and preprocess GloVe word vectors.

  Jeffrey Pennington, Richard Socher, and Christopher D. Manning. 2014.
  _GloVe: Global Vectors for Word Representation._

  https://nlp.stanford.edu/projects/glove/
  """

  @canonical_base_url     "http://nlp.stanford.edu/data/"
  @file_glove_6b          "glove.6B.zip"
  # @file_glove_42b         "glove.42B.300d.zip"
  # @file_glove_840b        "glove.840B.300d.zip"
  @file_glove_twitter_27b "glove.twitter.27B.zip"
  @glove_vecs %{
    {:glove_6b, 50} => {@file_glove_6b, 'glove.6B.50d.txt'},
    {:glove_6b, 100} => {@file_glove_6b, 'glove.6B.100d.txt'},
    {:glove_6b, 200} => {@file_glove_6b, 'glove.6B.200d.txt'},
    {:glove_6b, 300} => {@file_glove_6b, 'glove.6B.300d.txt'},

    # TODO getting {:error, :badmatch} on unzip # {:glove_42b, 300} => {@file_glove_42b, 'glove.42B.300d.txt'},

    # TODO getting {:error, :badmatch} on unzip # {:glove_840b, 300} => {@file_glove_840b, 'glove.840B.300d.txt'},

    {:glove_twitter_27b, 25} => {@file_glove_twitter_27b, 'glove.twitter.27B.25d.txt'},
    {:glove_twitter_27b, 50} => {@file_glove_twitter_27b, 'glove.twitter.27B.50d.txt'},
    {:glove_twitter_27b, 100} => {@file_glove_twitter_27b, 'glove.twitter.27B.100d.txt'},
    {:glove_twitter_27b, 200} => {@file_glove_twitter_27b, 'glove.twitter.27B.200d.txt'},
  }

  alias Scidata.Utils

  @doc ~S"""
  Download and unpack the requested GloVe vector file and parse it into word vectors.

  Available combinations of GloVe libraries and vector sizes are:

  - `:glove_6b`
    - 50
    - 100
    - 200
    - 300
  - `:glove_twitter_27b`
    - 25
    - 50
    - 100
    - 200

  ## Options

  - `:base_url` Overrides the canonical Stanford NLP data server URL for alternate hosting of GloVe files

  ## Examples

      iex> w2v = NLTEx.WordVectors.GloVe.download(:glove_6b, 50)
      iex> %NLTEx.WordVectors{vectors: _vectors_list, words: _words_list} = w2v
  """
  def download(lib, vec_size, opts \\ []) do
    base_url = Keyword.get(opts, :base_url, @canonical_base_url) |> IO.inspect()
    {lib_file, vec_file} = Map.get(@glove_vecs, {lib, vec_size})

    {words, vectors} = Utils.get!(base_url <> lib_file).body
    |> extract_vec_data(vec_file)
    |> process_vec_data(vec_size)

    NLTEx.WordVectors.new(words, vectors)
  end

  # Util function to handle extracting specific file from ZIPfile
  defp extract_vec_data(zipdata, vec_file) do
    {:ok, files} = :zip.unzip(zipdata, [:memory, {:file_list, [vec_file]}])
    files
    |> hd()
    |> elem(1)
  end

  # Util function to process raw data from ZIPfile into {words, vecs}
  defp process_vec_data(data, vec_size) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split/1)
    |> Enum.filter(fn x -> length(x) == vec_size + 1 end)
    |> Enum.map(fn [word | vec] -> {word, (for x <- vec, do: elem(Float.parse(x), 0))} end)
    |> Enum.unzip()
  end

end
