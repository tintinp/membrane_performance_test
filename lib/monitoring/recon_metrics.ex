defmodule Monitoring.ReconMetrics do
  import Telemetry.Metrics

  def metrics() do
    process_tags = [:group, :id]

    [
      # last_value("my_app.foo.value", tags: [:from, :operation]),
      # VM memory allocation
      last_value("recon_alloc.memory.used.value"),
      last_value("recon_alloc.memory.allocated.value"),
      last_value("recon_alloc.memory.unused.value"),

      # Process memory info
      last_value("recon.process.memory_used.binary_memory.value", tags: process_tags),
      last_value("recon.process.memory_used.memory.value", tags: process_tags),
      last_value("recon.process.memory_used.message_queue_len.value", tags: process_tags),
      last_value("recon.process.memory_used.heap_size.value", tags: process_tags),
      last_value("recon.process.memory_used.total_heap_size.value", tags: process_tags),
      last_value("recon.process.memory_used.garbage_collection.min_bin_vheap_size.value",
        tags: process_tags
      ),
      last_value("recon.process.memory_used.garbage_collection.min_heap_size.value",
        tags: process_tags
      ),
      last_value("recon.process.memory_used.garbage_collection.fullsweep_after.value",
        tags: process_tags
      ),
      last_value("recon.process.memory_used.garbage_collection.minor_gcs.value",
        tags: process_tags
      ),

      # Process work info
      last_value("recon.process.work.reductions.value", tags: process_tags)
    ]
  end

  def monitor_memory() do
    memory_used = :recon_alloc.memory(:used)
    memory_allocaed = :recon_alloc.memory(:allocated)
    memory_unused = :recon_alloc.memory(:unused)

    :telemetry.execute([:recon_alloc, :memory, :used], %{value: memory_used})
    :telemetry.execute([:recon_alloc, :memory, :allocated], %{value: memory_allocaed})
    :telemetry.execute([:recon_alloc, :memory, :unused], %{value: memory_unused})
  end

  @doc """
  Currently monitors only process memory

  Get info by calling
    :recon.info(pid)

  `info/1` function returns the following
  [
    ...
    memory_used: [
      memory: 1272552,
      message_queue_len: 0,
      heap_size: 75113,
      total_heap_size: 158955,
      garbage_collection: [
        max_heap_size: %{
          error_logger: true,
          include_shared_binaries: false,
          kill: true,
          size: 0
        },
        min_bin_vheap_size: 46422,
        min_heap_size: 233,
        fullsweep_after: 65535,
        minor_gcs: 4
    ]
    ...
  ]
  """
  def monitor_process_info(pid, tag) do
    metric_tag = %{group: tag.group, id: tag.id}
    info = :recon.info(pid)
    {:binary_memory, binary_memory} = :recon.info(pid, :binary_memory)

    mem_used = Keyword.get(info, :memory_used)
    gc = Keyword.get(mem_used, :garbage_collection)
    memory = Keyword.get(mem_used, :memory)
    message_queue_len = Keyword.get(mem_used, :message_queue_len)
    heap_size = Keyword.get(mem_used, :heap_size)
    total_heap_size = Keyword.get(mem_used, :total_heap_size)
    min_bin_vheap_size = Keyword.get(gc, :min_bin_vheap_size)
    min_heap_size = Keyword.get(gc, :min_heap_size)
    fullsweep_after = Keyword.get(gc, :fullsweep_after)
    minor_gcs = Keyword.get(gc, :minor_gcs)
    reductions = Keyword.get(Keyword.get(info, :work), :reductions)

    :telemetry.execute(
      [:recon, :process, :memory_used, :binary_memory],
      %{value: binary_memory},
      metric_tag
    )

    :telemetry.execute([:recon, :process, :memory_used, :memory], %{value: memory}, metric_tag)

    :telemetry.execute(
      [:recon, :process, :memory_used, :message_queue_len],
      %{
        value: message_queue_len
      },
      metric_tag
    )

    :telemetry.execute(
      [:recon, :process, :memory_used, :heap_size],
      %{value: heap_size},
      metric_tag
    )

    :telemetry.execute(
      [:recon, :process, :memory_used, :total_heap_size],
      %{
        value: total_heap_size
      },
      metric_tag
    )

    :telemetry.execute(
      [:recon, :process, :memory_used, :garbage_collection, :min_bin_vheap_size],
      %{
        value: min_bin_vheap_size
      },
      metric_tag
    )

    :telemetry.execute(
      [:recon, :process, :memory_used, :garbage_collection, :min_heap_size],
      %{value: min_heap_size},
      metric_tag
    )

    :telemetry.execute(
      [:recon, :process, :memory_used, :garbage_collection, :fullsweep_after],
      %{
        value: fullsweep_after
      },
      metric_tag
    )

    :telemetry.execute([:recon, :process, :memory_used, :garbage_collection, :minor_gcs], %{
      value: minor_gcs
    })

    :telemetry.execute([:recon, :process, :work, :reductions], %{value: reductions}, metric_tag)
  end
end
