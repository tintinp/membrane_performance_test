defmodule Membrane.Pipeline.Tee do
  use Membrane.Pipeline

  @impl true
  def handle_init(_context, _options) do
    spec = [
      child(:buffer_push_source, %Membrane.TestElement.BufferPushSource{
        group: "BufferPushSource",
        id: "1"
      })
      |> child(:tee, Membrane.Tee.Parallel)
      |> child(:output, %Membrane.TestElement.BufferSink{
        group: "BufferSink",
        id: "1"
      })
    ]

    {[spec: spec], %{}}
  end

  def start_link(_options) do
    {:ok, supervisor_pid, pipeline_pid} = Membrane.Pipeline.start_link(__MODULE__, nil)
    {:ok, supervisor_pid, pipeline_pid}
  end
end
