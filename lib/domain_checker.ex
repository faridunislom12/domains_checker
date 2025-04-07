defmodule DomainChecker do
  def start(domains) do
    Enum.each(domains, fn domain ->
      Task.start(fn -> loop(domain) end)
    end)
  end

  defp loop(domain) do
    result = check_domain(domain)

    log_results(domain, result)

    :timer.sleep(60_000)
    loop(domain)
  end

  defp check_domain(domain) do
    case :gen_tcp.connect(String.to_charlist(domain), 80, [:binary, active: false], 5000) do
      {:ok, socket} ->
        :gen_tcp.close(socket)
        1
        #IO.puts("[OK] #{domain} — reachable on port 80")

      {:error, reason} ->
        0
        #IO.puts("[DEAD] #{domain} — #{inspect(reason)}")
    end
  end

    defp log_results(domain, result) do
      log_dir = "logs/checker"
      File.mkdir_p!(log_dir)

      log_file = Path.join(log_dir, "#{domain}.log")
      timestamp = DateTime.utc_now() |> DateTime.to_string()
      line = "#{timestamp} — #{result}\n"

      case File.write(log_file, line, [:append]) do
        _ -> :ok  # do nothing if successful IO.puts("[LOGGED] #{domain} — #{result}")
        {:error, reason} -> IO.puts("[ERROR] Failed to write log: #{inspect(reason)}")
      end
    end

end
