defmodule Membrane.Pipeline.Parallel do
  use Membrane.Pipeline

  def start_link(options) do
    {:ok, supervisor_pid, pipeline_pid} = Membrane.Pipeline.start_link(__MODULE__, options)
    {:ok, supervisor_pid, pipeline_pid}
  end

  @impl true
  def handle_init(_context, options) do
    spec = [
      child(:buffer_push_source, %Membrane.TestElement.BufferPushSource{
        group: "PushSource",
        id: "1",
        push_interval: options.source_push_interval,
        buffer_size: options.buffer_size
      })
      |> child(:tee, Membrane.Tee.Parallel)
    ]

    parallel = create_parallel(options.parallel_count)

    {[spec: spec ++ parallel], %{}}
  end

  defp create_parallel(n) when n > 0 do
    Enum.map(1..n, fn id ->
      get_child(:tee)
      |> child({:buffer_passthrough, id}, %Membrane.TestElement.BufferPassthrough{
        group: "Passthrough",
        id: Integer.to_string(id)
      })
      |> child({:buffer_filter, id}, %Membrane.TestElement.BufferFilter{
        group: "Filter",
        id: Integer.to_string(id),
        delay: 0
      })
      |> child({:buffer_sink, id}, %Membrane.TestElement.BufferSink{
        group: "Sink",
        id: Integer.to_string(id),
        delay: 0
      })
    end)
  end
end
