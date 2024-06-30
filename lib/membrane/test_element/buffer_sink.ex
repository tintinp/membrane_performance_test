defmodule Membrane.TestElement.BufferSink do
  use Membrane.Sink
  use Membrane.Monitoring.ReconProcessMonitoring

  def_options(
    group: [
      spec: String.t(),
      description: "Membrane group name, eg. 'Tees'"
    ],
    id: [
      spec: String.t(),
      description: "Unique element id"
    ]
  )

  def_input_pad(:input,
    flow_control: :auto,
    accepted_format: _any
  )

  @impl true
  def handle_init(_context, options) do
    {[], %{group: options.group, id: options.id}}
  end

  @impl true
  def handle_setup(_ctx, state) do
    collect_process_info()
    {[], state}
  end

  @impl true
  def handle_playing(_context, state) do
    # {[demand: {:input, 1}], state}
    {[], state}
  end

  @impl true
  def handle_buffer(:input, buffer, _context, state) do
    {[], state}
  end
end
