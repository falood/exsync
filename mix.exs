defmodule ExSync.Mixfile do
  use Mix.Project

  def project do
    [
      app: :exsync,
      version: "0.2.4",
      elixir: "~> 1.3",
      elixirc_paths: ["lib", "web"],
      deps: deps(),
      description: "Yet another Elixir reloader.",
      source_url: "https://github.com/falood/exsync",
      package: package(),
      docs: [
        extras: ["README.md"],
        main: "readme"
      ]
    ]
  end

  def application do
    [mod: {ExSync, []}, applications: [:logger]]
  end

  defp deps do
    [{:ex_doc, "~> 0.14", only: :docs}, {:file_system, "~> 0.2"}]
  end

  defp package do
    %{
      maintainers: ["Xiangrong Hao"],
      licenses: ["BSD 3-Clause"],
      links: %{"Github" => "https://github.com/falood/exsync"}
    }
  end
end
