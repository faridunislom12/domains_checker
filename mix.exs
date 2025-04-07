defmodule DomainChecker.MixProject do
  use Mix.Project

  def project do
    [
      app: :domain_checker,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {DomainChecker.Application, []},
      extra_applications: [:logger, :httpoison]
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.8"}
    ]
  end
end