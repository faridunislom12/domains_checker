defmodule DomainChecker.Manager do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    urls =
      File.read!("urls.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.trim/1)

    Enum.each(urls, fn domain ->
      DomainChecker.Worker.start_link(domain)
    end)

    {:ok, %{}}
  end
end
