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
      extra_applications: [:logger, :finch],
      mod: {DomainChecker, []}  # Указываем, что при старте будет вызвана функция start/2 из модуля DomainChecker
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.8"},
      {:finch, "~> 0.15"}
    ]
  end
end
