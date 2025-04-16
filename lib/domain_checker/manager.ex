defmodule DomainChecker.Manager do
  use GenServer

  alias DomainChecker.Worker

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    urls =
      File.read!("urls.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.trim/1)

    IO.inspect(urls)

    Enum.each(urls, fn domain ->
      DynamicSupervisor.start_child(DomainChecker.DynamicSupervisor, {Worker, domain})
    end)

    {:ok, %{}}
  end
end
