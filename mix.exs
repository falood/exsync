defmodule ExSync.Mixfile do
  use Mix.Project

  def project do
    [ app: :exsync,
      version: "0.0.1",
      elixir: "~> 1.0",
      elixirc_paths: ["lib", "web"],
      deps: deps,
    ]
  end

  def application do
    [ mod: { ExSync, [] },
      applications: [:exfswatch, :logger],
    ]
  end

  defp deps do
    [ {:exfswatch, github: "falood/exfswatch"} ]
  end
end
