defmodule NLTEx.MixProject do
  use Mix.Project

  @version "0.1.0"
  @repo_url "https://github.com/arpieb/nltex"

  def project do
    [
      app: :nltex,
      version: @version,
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Hex
      package: package(),
      description: "Natural Language Toolkit for Elixir",

      # Docs
      name: "NLTEx",
      docs: docs(),
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:scidata, "~> 0.1.2"},
      {:ex_doc, ">= 0.24.0", only: :dev, runtime: false},
    ]
  end

  defp package do
    [
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @repo_url},
    ]
  end

  defp docs do
    [
      source_ref: "v#{@version}",
      source_url: @repo_url,
      logo: "assets/doc-icon.png",
      extras: ["README.md", "LICENSE"],
    ]
  end
end
