defmodule MembranePerformanceTest.Monitoring.PromExPlugin do
  use PromEx.Plugin

  @process_memory_usage [:membrane_performance_test, :process, :memory_used]
  @process_work_usage [:membrane_performance_test, :process, :work]

  @impl true
  def event_metrics(_opts) do
    [
      process_event_metrics()
    ]
  end

  defp process_event_metrics() do
    Event.build(
      :membrane_performance_test_process_event_metrics,
      [
        last_value(
          @process_memory_usage ++ [:binary_memory, :value],
          event_name: @process_memory_usage ++ [:binary_memory],
          description: "Binary memory used by a process",
          tags: [:group, :id],
          tag_values: &get_process_tag_values/1
        ),
        last_value(
          @process_memory_usage ++ [:memory, :value],
          event_name: @process_memory_usage ++ [:memory],
          description: "Memory used by a process",
          tags: [:group, :id],
          tag_values: &get_process_tag_values/1
        ),
        last_value(
          @process_memory_usage ++ [:message_queue_len, :value],
          event_name: @process_memory_usage ++ [:message_queue_len],
          description: "message_queue_len used by a process",
          tags: [:group, :id],
          tag_values: &get_process_tag_values/1
        ),
        last_value(
          @process_memory_usage ++ [:heap_size, :value],
          event_name: @process_memory_usage ++ [:heap_size],
          description: "heap_size used by a process",
          tags: [:group, :id],
          tag_values: &get_process_tag_values/1
        ),
        last_value(
          @process_memory_usage ++ [:total_heap_size, :value],
          event_name: @process_memory_usage ++ [:total_heap_size],
          description: "total_heap_size used by a process",
          tags: [:group, :id],
          tag_values: &get_process_tag_values/1
        ),
        last_value(
          @process_memory_usage ++ [:garbage_collection, :min_bin_vheap_size, :value],
          event_name: @process_memory_usage ++ [:garbage_collection, :min_bin_vheap_size],
          description: "garbage_collection:min_bin_vheap_size used by a process",
          tags: [:group, :id],
          tag_values: &get_process_tag_values/1
        ),
        last_value(
          @process_memory_usage ++ [:garbage_collection, :min_heap_size, :value],
          event_name: @process_memory_usage ++ [:garbage_collection, :min_heap_size],
          description: "garbage_collection:min_heap_size used by a process",
          tags: [:group, :id],
          tag_values: &get_process_tag_values/1
        ),
        last_value(
          @process_memory_usage ++ [:garbage_collection, :fullsweep_after, :value],
          event_name: @process_memory_usage ++ [:garbage_collection, :fullsweep_after],
          description: "garbage_collection:fullsweep_after used by a process",
          tags: [:group, :id],
          tag_values: &get_process_tag_values/1
        ),
        last_value(
          @process_memory_usage ++ [:garbage_collection, :minor_gcs, :value],
          event_name: @process_memory_usage ++ [:garbage_collection, :minor_gcs],
          description: "garbage_collection:minor_gcs used by a process",
          tags: [:group, :id],
          tag_values: &get_process_tag_values/1
        ),
        last_value(
          @process_work_usage ++ [:reductions, :value],
          event_name: @process_work_usage ++ [:reductions],
          description: "process reductions",
          tags: [:group, :id],
          tag_values: &get_process_tag_values/1
        )
      ]
    )
  end

  defp get_process_tag_values(%{group: group, id: id}) do
    %{group: group, id: id}
  end
end
