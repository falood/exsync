defmodule ExSync.Mixfile do
  use Mix.Project

  @source_url "https://github.com/falood/exsync"
  @version "0.4.1"

  def project do
    [
      app: :exsync,
      version: @version,
      elixir: "~> 1.11",
      elixirc_paths: ["lib", "web"],
      deps: deps(),
      description: "Yet another Elixir reloader.",
      source_url: @source_url,
      homepage_url: @source_url,
      package: package(),
      docs: docs()
    ]
  end

  def application do
    [
      mod: {ExSync.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.14", only: :docs},
      {:file_system, "~> 1.0 or ~> 0.2"}
    ]
  end

  defp package do
    %{
      maintainers: ["Xiangrong Hao", "Jason Axelson"],
      licenses: ["BSD-3-Clause"],
      links: %{"Github" => "https://github.com/falood/exsync"}
    }
  end

  defp docs do
    [
      extras: [
        "README.md": [],
        "CHANGELOG.md": [],
        LICENSE: [title: "License"]
      ],
      main: "readme",
      source_ref: "v#{@version}"
    ]
  end
end
