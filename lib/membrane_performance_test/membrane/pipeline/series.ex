defmodule MembranePerformanceTest.Membrane.Pipeline.Series do
  use Membrane.Pipeline

  def start_link(options) do
    {:ok, supervisor_pid, pipeline_pid} =
      Membrane.Pipeline.start_link(__MODULE__, options)

    {:ok, supervisor_pid, pipeline_pid}
  end

  @impl true
  def handle_init(_context, options) do
    spec = [
      child(:buffer_push_source, %MembranePerformanceTest.Membrane.TestElement.BufferPushSource{
        group: "PushSource",
        id: "1",
        push_interval: options.source_push_interval,
        buffer_size: options.buffer_size
      })
    ]

    filters = create_filter(options.series_count)

    sink = [
      get_child({:buffer_filter, options.series_count})
      |> child(:buffer_sink, %MembranePerformanceTest.Membrane.TestElement.BufferSink{
        group: "Sink",
        id: "1",
        delay: 0
      })
    ]

    {[spec: spec ++ filters ++ sink], %{}}
  end

  defp create_filter(n) when n > 0 do
    IO.puts("Creating #{inspect(n)} filters")

    first_filter = [
      get_child(:buffer_push_source)
      |> child(
        {:buffer_passthrough, 1},
        %MembranePerformanceTest.Membrane.TestElement.BufferPassthrough{
          group: "Passthrough",
          id: Integer.to_string(1)
        }
      )
      |> child({:buffer_filter, 1}, %MembranePerformanceTest.Membrane.TestElement.BufferFilter{
        group: "Filter",
        id: Integer.to_string(1),
        delay: 0
      })
    ]

    filters =
      Enum.map(2..n, fn id ->
        get_child({:buffer_filter, id - 1})
        |> child(
          {:buffer_passthrough, id},
          %MembranePerformanceTest.Membrane.TestElement.BufferPassthrough{
            group: "Passthrough",
            id: Integer.to_string(id)
          }
        )
        |> child({:buffer_filter, id}, %MembranePerformanceTest.Membrane.TestElement.BufferFilter{
          group: "Filter",
          id: Integer.to_string(id),
          delay: 0
        })
      end)

    first_filter ++ filters
  end
end
