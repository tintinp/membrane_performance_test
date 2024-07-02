defmodule MembranePerformanceTest.Membrane.TestElement.BufferFilter do
  use Membrane.Filter
  alias MembranePerformanceTest.Membrane.Monitoring.ReconProcessMonitoring

  def_options(
    group: [
      spec: String.t(),
      description: "Membrane group name, eg. 'Tees'"
    ],
    id: [
      spec: String.t(),
      description: "Unique element id"
    ],
    delay: [
      spec: pos_integer(),
      description: "handle_buffer delay in ms",
      default: 0
    ]
  )

  def_input_pad(:input,
    flow_control: :auto,
    accepted_format: _any
  )

  def_output_pad(:output,
    flow_control: :auto,
    accepted_format: _any
  )

  @impl true
  def handle_init(_context, options) do
    {
      [],
      %{
        group: options.group,
        id: options.id,
        delay: options.delay,
        buffer_metric_emitter: nil
      }
    }
  end

  @impl true
  def handle_setup(_ctx, state) do
    ReconProcessMonitoring.start_link(%ReconProcessMonitoring{
      pid: self(),
      group: state.group,
      id: state.id
    })

    {:ok, pid} =
      MembranePerformanceTest.Monitoring.BufferMetricEmitter.start_link(%{
        group: state.group,
        id: state.id
      })

    {[], %{state | buffer_metric_emitter: pid}}
  end

  @impl true
  def handle_buffer(:input, buffer, _context, state) do
    # Logger.debug(
    #   "#{inspect(state.id)} Received buffer of size #{inspect(byte_size(buffer.payload))} bytes"
    # )
    MembranePerformanceTest.Monitoring.BufferMetricEmitter.record_data(
      state.buffer_metric_emitter,
      byte_size(buffer.payload)
    )

    :timer.sleep(state.delay)
    {[buffer: {:output, buffer}], state}
  end
end
