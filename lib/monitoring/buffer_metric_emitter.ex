defmodule Monitoring.BufferMetricEmitter do
  use GenServer
  import Telemetry.Metrics

  ####################
  # Client API
  ####################

  def start_link(server_opts, gen_server_opt \\ []) do
    GenServer.start(__MODULE__, server_opts, gen_server_opt)
  end

  def record_data(server, buffer_size) do
    GenServer.cast(server, {:buffer_size, buffer_size})
  end

  ####################
  # Server handler
  ####################

  def init(server_opts) do
    now = DateTime.utc_now()
    collect_metrics()

    {
      :ok,
      %{
        last_reported_time: now,
        byte_count: 0,
        buffer_count: 0,
        group: server_opts.group,
        id: server_opts.id
      }
    }
  end

  def handle_info(:emit_metrics, state) do
    now = DateTime.utc_now()
    curr_byte_count = state.byte_count
    curr_buffer_count = state.buffer_count

    metric_tag = %{group: state.group, id: state.id}

    :telemetry.execute(
      [:buffer_element, :rate, :byte_size],
      %{value: curr_byte_count},
      metric_tag
    )

    :telemetry.execute(
      [:buffer_element, :rate, :buffer_count],
      %{value: curr_buffer_count},
      metric_tag
    )

    state =
      state
      |> put_in([:last_reported_time], now)
      |> put_in([:byte_count], 0)
      |> put_in([:buffer_count], 0)

    collect_metrics()
    {:noreply, state}
  end

  defp collect_metrics() do
    Process.send_after(self(), :emit_metrics, 1000)
  end

  def handle_cast({:buffer_size, buffer_size}, state) do
    curr_byte_count = state.byte_count + buffer_size
    curr_buffer_count = state.buffer_count + 1

    state =
      state
      |> put_in([:byte_count], curr_byte_count)
      |> put_in([:buffer_count], curr_buffer_count)

    {:noreply, state}
  end

  def metrics() do
    process_tags = [:group, :id]

    [
      last_value("buffer_element.rate.byte_size.value", tags: process_tags),
      last_value("buffer_element.rate.buffer_count.value", tags: process_tags)
    ]
  end
end
