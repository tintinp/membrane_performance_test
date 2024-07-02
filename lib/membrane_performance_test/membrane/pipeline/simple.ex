defmodule MembranePerformanceTest.Membrane.Pipeline.Simple do
  use Membrane.Pipeline

  def start_link(_options) do
    {:ok, supervisor_pid, pipeline_pid} =
      Membrane.Pipeline.start_link(__MODULE__, nil)

    {:ok, supervisor_pid, pipeline_pid}
  end

  @impl true
  def handle_init(_context, _options) do
    spec = [
      child(:buffer_push_source, %MembranePerformanceTest.Membrane.TestElement.BufferPushSource{
        group: "PushSource",
        id: "1",
        push_interval: 1000,
        buffer_size: 1024 * 1024
      })
      |> child(
        :buffer_passthrough,
        %MembranePerformanceTest.Membrane.TestElement.BufferPassthrough{
          group: "Passthrough",
          id: "1"
        }
      )
      |> child(:buffer_filter, %MembranePerformanceTest.Membrane.TestElement.BufferFilter{
        group: "Filter",
        id: "1",
        delay: 0
      })
      |> child(:buffer_sink, %MembranePerformanceTest.Membrane.TestElement.BufferSink{
        group: "Sink",
        id: "1",
        delay: 0
      })
    ]

    {[spec: spec], %{}}
  end
end
