defmodule Resin.Mixfile do
  use Mix.Project

  def project do
    [app: :resin,
      version: "0.4.1",
      elixir: "~> 1.0",
      description: description,
      package: package,
      deps: deps]
  end

  def application do
    [applications: [:logger, :plug]]
  end

  defp description do
    """
    Pour resin in your plug pipeline to add (configurable) enterpriseyness!
    """
  end

  defp package do
    [ files: ~w[ lib README.md mix.exs LICENSE ],
      contributors: ["Martin Frost"],
      licenses: ["The MIT License (MIT)"],
      links: %{
        "GitHub" => "https://github.com/Frost/resin",
        "Docs" => "http://hexdocs.pm/resin/" } ]
  end

  defp deps do
    [{:plug, "~> 1.0"},
     {:earmark, ">= 0.0.0", only: :dev},
     {:credo, "~> 0.1", only: :dev},
     {:ex_doc, "~> 0.10", only: :dev}]
  end
end
