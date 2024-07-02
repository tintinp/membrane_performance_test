defmodule MembranePerformanceTest.Membrane.TestElement.BufferPassthrough do
  alias MembranePerformanceTest.Membrane.Monitoring.ReconProcessMonitoring
  alias Membrane.Logger
  use Membrane.Filter

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
    availability: :on_request,
    accepted_format: _any
  )

  def_output_pad(:output,
    flow_control: :auto,
    accepted_format: _any
  )

  @impl true
  def handle_init(_context, options) do
    {[], %{group: options.group, id: options.id}}
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
  def handle_buffer(_pad, buffer, _ctx, state) do
    {[buffer: {:output, buffer}], state}
  end

  @impl true
  def handle_pad_added(pad, _ctx, state) do
    Logger.debug("passthrough pad added #{inspect(pad)}")
    {[], state}
  end

  @impl true
  # need to implement this or else END OF STREAM event will be sent to output pad when input pad's link is removed
  def handle_pad_removed(pad, _ctx, state) do
    Logger.debug("passthrough pad removed #{inspect(pad)}")
    {[], state}
  end

  @impl true
  def handle_end_of_stream(pad, _ctx, state) do
    Logger.debug("passthrough GOT EOS #{inspect(pad)}")
    {[], state}
  end
end
