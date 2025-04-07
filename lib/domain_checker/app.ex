defmodule DomainChecker.Application do
  use Application

  def start(_type, _args) do
    urls =
      File.read!("urls.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.trim/1)

    Task.start(fn ->
      DomainChecker.start(urls)
    end)

    # чтобы Application не завершился
    children = []
    opts = [strategy: :one_for_one, name: DomainChecker.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
