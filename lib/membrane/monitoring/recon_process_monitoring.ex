defmodule Membrane.Monitoring.ReconProcessMonitoring do
  use GenServer

  @interval Application.compile_env(
              :membrane_performance_test,
              [:process_monitoring, :interval],
              3000
            )

  @enforce_keys [:pid, :group, :id]

  defstruct @enforce_keys

  # Client API

  def start_link(%Membrane.Monitoring.ReconProcessMonitoring{} = server_options) do
    GenServer.start_link(__MODULE__, server_options, [])
  end

  # Server handler
  @impl true
  def init(%Membrane.Monitoring.ReconProcessMonitoring{} = server_options) do
    {
      :ok,
      %{pid: server_options.pid, group: server_options.group, id: server_options.id},
      {:continue, :start_collection}
    }
  end

  @impl true
  def handle_continue(:start_collection, state) do
    collect_process_info()
    {:noreply, state}
  end

  @impl true
  def handle_info(:collect_process_info, state) do
    Monitoring.ReconMetrics.monitor_process_info(state.pid, %{group: state.group, id: state.id})

    collect_process_info()
    {:noreply, state}
  end

  defp collect_process_info() do
    Process.send_after(self(), :collect_process_info, @interval)
  end
end
