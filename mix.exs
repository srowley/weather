defmodule Weather.MixProject do
  use Mix.Project

  def project do
    [
      app: :weather,
      escript: escript_config(),
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      {:sweet_xml, "~> 0.6.5"},
      {:httpoison, "~> 1.0.0"}
    ]
  end

  defp escript_config do
    [
      main_module: Weather.CLI
    ]
  end
end
