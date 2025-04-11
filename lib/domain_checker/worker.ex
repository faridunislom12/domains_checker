defmodule DomainChecker.Worker do
  use GenServer

  def start_link(domain) do
    GenServer.start_link(__MODULE__, domain, name: via_tuple(domain))
  end

  def init(domain) do
    {:ok, {domain, []}, {:continue, :check_loop}}
  end

  def handle_continue(:check_loop, {domain, results}) do
    result = check_domain(domain)

    :timer.sleep(10_000)

    timestamp = DateTime.utc_now() |> DateTime.to_iso8601()
    updated_results = results ++ [{timestamp, result}]

    log_results(domain, updated_results)

    {:noreply, {domain, updated_results}, {:continue, :check_loop}}
  end

  # --- Helpers ---

  defp check_domain(domain) do
    case :gen_tcp.connect(String.to_charlist(domain), 80, [:binary, active: false], 5000) do
      {:ok, socket} ->
        :gen_tcp.close(socket)
        1

      {:error, reason} ->
        #log_result(domain, reason)
        0
    end
  end

  defp log_result(domain, result) do
    log_dir = "logs/checker"
    File.mkdir_p!(log_dir)

    log_file = Path.join(log_dir, "#{domain}.log")
    timestamp = DateTime.utc_now() |> DateTime.to_string()
    line = "#{timestamp} — #{result}\n"

    case File.write(log_file, line, [:append]) do
      :ok -> :ok
      {:error, reason} -> IO.puts("[ERROR] Failed to write log: #{inspect(reason)}")
    end
  end

  defp log_results(domain, result) do
    log_dir = "logs/checker"
    File.mkdir_p!(log_dir)

    log_file = Path.join(log_dir, "#{domain}.log")

    result_string =
      Enum.map(result, fn {timestamp, res} ->
        "#{timestamp} — #{res}"
      end)
      |> Enum.join("\n")  # Join entries with newline if multiple

    line = "#{result_string}\n\n"

    case File.write(log_file, line, [:append]) do
      :ok -> :ok
      {:error, reason} -> IO.puts("[ERROR] Failed to write log: #{inspect(reason)}")
    end
  end

  defp via_tuple(domain) do
    {:via, Registry, {DomainChecker.Registry, domain}}
  end
end
