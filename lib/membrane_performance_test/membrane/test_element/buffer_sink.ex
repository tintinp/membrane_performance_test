defmodule MembranePerformanceTest.Membrane.TestElement.BufferSink do
  use Membrane.Sink
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

  @impl true
  def handle_init(_context, options) do
    {[], %{group: options.group, id: options.id, delay: options.delay}}
  end

  @impl true
  def handle_setup(_ctx, state) do
    ReconProcessMonitoring.start_link(%ReconProcessMonitoring{
      pid: self(),
      group: state.group,
      id: state.id
    })

    {[], state}
  end

  @impl true
  def handle_playing(_context, state) do
    # {[demand: {:input, 1}], state}
    {[], state}
  end

  @impl true
  def handle_buffer(:input, _buffer, _context, state) do
    :timer.sleep(state.delay)
    {[], state}
  end
end
