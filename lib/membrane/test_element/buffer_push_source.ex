defmodule Membrane.TestElement.BufferPushSource do
  use Membrane.Source
  alias Membrane.Buffer
  alias Membrane.Monitoring.ReconProcessMonitoring

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

  def_output_pad(:output,
    accepted_format: %Membrane.Format.RawBuffer{format: :bytes},
    flow_control: :push
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
  def handle_playing(_ctx, state) do
    push_buffer()
    {[stream_format: {:output, %Membrane.Format.RawBuffer{format: :bytes}}], state}
  end

  def handle_info(:push_buffer, _ctx, state) do
    push_buffer()
    {[buffer: {:output, %Buffer{payload: create_100kb_buffer()}}], state}
  end

  defp push_buffer() do
    Process.send_after(self(), :push_buffer, 1000)
  end

  defp create_100kb_buffer() do
    :binary.copy(<<0>>, 1_024 * 1_024)
  end
end
