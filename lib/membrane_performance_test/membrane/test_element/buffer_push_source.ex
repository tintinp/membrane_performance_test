defmodule MembranePerformanceTest.Membrane.TestElement.BufferPushSource do
  use Membrane.Source
  alias Membrane.Buffer
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
    push_interval: [
      spec: pos_integer(),
      description: "Interval to push buffer in ms. Default 1000 ms",
      default: 1000
    ],
    buffer_size: [
      spec: pos_integer(),
      description: "Size of buffer to push in bytes. Default: 1024 bytes",
      default: 1_024
    ]
  )

  def_output_pad(:output,
    accepted_format: %MembranePerformanceTest.Membrane.Format.RawBuffer{format: :bytes},
    flow_control: :push
  )

  @impl true
  def handle_init(_context, options) do
    {[],
     %{
       group: options.group,
       id: options.id,
       push_interval: options.push_interval,
       buffer_size: options.buffer_size
     }}
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
  def handle_playing(_ctx, state) do
    push_buffer(state.push_interval)

    {[
       stream_format:
         {:output, %MembranePerformanceTest.Membrane.Format.RawBuffer{format: :bytes}}
     ], state}
  end

  def handle_info(:push_buffer, _ctx, state) do
    push_buffer(state.push_interval)
    {[buffer: {:output, %Buffer{payload: create_buffer(state.buffer_size)}}], state}
  end

  defp push_buffer(push_interval) do
    Process.send_after(self(), :push_buffer, push_interval)
  end

  defp create_buffer(buffer_size) do
    :binary.copy(<<0>>, buffer_size)
  end
end
