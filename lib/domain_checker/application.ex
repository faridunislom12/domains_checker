defmodule DomainChecker.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: DomainChecker.Registry},
      DomainChecker.Manager
    ]

    opts = [strategy: :one_for_one, name: DomainChecker.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
