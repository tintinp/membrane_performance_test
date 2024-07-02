defmodule MembranePerformanceTest.Monitoring.ReconVmMonitoring do
  use GenServer

  @interval Application.compile_env(
              :membrane_performance_test,
              [:vm_monitoring, :interval],
              3000
            )

  def start_link(server_options) do
    gen_server_opts = if server_options[:name] == nil, do: [], else: [name: server_options[:name]]
    server_options = Enum.into(server_options, %{})
    GenServer.start_link(__MODULE__, server_options, gen_server_opts)
  end

  def init(_) do
    collect_memory()
    {:ok, %{}}
  end

  def handle_info(:collect_memory, state) do
    MembranePerformanceTest.Monitoring.ReconMetrics.monitor_memory()
    collect_memory()
    {:noreply, state}
  end

  defp collect_memory() do
    Process.send_after(self(), :collect_memory, @interval)
  end
end
