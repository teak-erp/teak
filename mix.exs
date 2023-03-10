defmodule Teak.MixProject do
  use Mix.Project

  def project do
    [
      app: :teak,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  # def application do
  #   [
  #     extra_applications: [:logger]
  #   ]
  # end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:spark, path: "../../spark", override: true},
      {:ash, path: "../../ash", override: true},
      {:ash_postgres, "~> 1.1.1"},

      {:elixir_sense, github: "elixir-lsp/elixir_sense", only: [:dev, :test], override: true},
    ]
  end
end
