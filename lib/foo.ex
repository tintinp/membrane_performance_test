defmodule Foo do
  use GenServer

  @interval Application.compile_env(
              :membrane_performance_test,
              [:process_monitoring, :interval],
              3000
            )

  # Client API

  def start_link(opt) do
    GenServer.start(__MODULE__, nil, opt)
  end

  def emit(server) do
    GenServer.call(server, :emit, 1_000_000)
  end

  def sleep(server) do
    GenServer.cast(server, :sleep)
  end

  def store_buffer(server) do
    GenServer.call(server, :store_buffer)
  end

  def release_buffer(server) do
    GenServer.call(server, :release_buffer)
  end

  # Server handler

  def init(_) do
    # collect_process_info()
    {:ok, %{buffer: []}}
  end

  def handle_info(:collect_process_info, state) do
    MembranePerformanceTest.Monitoring.ReconMetrics.monitor_process_info(self(), %{
      group: "Foo",
      id: "foo_1"
    })

    collect_process_info()
    {:noreply, state}
  end

  defp collect_process_info() do
    Process.send_after(self(), :collect_process_info, @interval)
  end

  def handle_call(:store_buffer, _from, state) do
    buffer = create_100kb_buffer()
    {:reply, :ok, %{state | buffer: [buffer | state.buffer]}}
  end

  def handle_call(:release_buffer, _from, state) do
    {:reply, :ok, %{state | buffer: nil}}
  end

  def handle_call(:emit, _from, state) do
    IO.puts("hello!")
    :timer.sleep(3000)
    :telemetry.execute([:my_app, :foo], %{value: 5}, %{from: "a", operation: "1"})
    IO.puts("emitted!!")
    {:reply, :ok, state}
  end

  def handle_cast(:sleep, state) do
    IO.puts("sleeping")
    :timer.sleep(10000)
    IO.puts("done")
    {:noreply, state}
  end

  defp create_100kb_buffer do
    :binary.copy(<<0>>, 100 * 1_024)
  end
end
