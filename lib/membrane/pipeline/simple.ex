defmodule Membrane.Pipeline.Simple do
  use Membrane.Pipeline

  def start_link(_options) do
    {:ok, supervisor_pid, pipeline_pid} = Membrane.Pipeline.start_link(__MODULE__, nil)
    {:ok, supervisor_pid, pipeline_pid}
  end

  @impl true
  def handle_init(_context, _options) do
    spec = [
      child(:buffer_push_source, %Membrane.TestElement.BufferPushSource{
        group: "BufferPushSource",
        id: "1",
        push_interval: 1000,
        buffer_size: 1024 * 1024
      })
      |> child(:buffer_filter, %Membrane.TestElement.BufferFilter{
        group: "BufferFilter",
        id: "1",
        delay: 0
      })
      |> child(:buffer_sink, %Membrane.TestElement.BufferSink{
        group: "BufferSink",
        id: "1",
        delay: 0
      })
    ]

    {[spec: spec], %{}}
  end
end
