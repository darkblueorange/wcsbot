defmodule Wcsbot.MixProject do
  use Mix.Project

  def project do
    [
      app: :wcsbot,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :websocket_client],
      mod: {Wcsbot.Application, []}
      # mod: {MyBot, []}

    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:alchemy, "~> 0.7.0", hex: :discord_alchemy},
      # {:postgrex, "~> 0.16.0"}
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"}
    ]
  end
end
