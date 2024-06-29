defmodule Monitoring.VMStatsSink do
  @behaviour :vmstats_sink
  import Telemetry.Metrics

  def collect(:counter, key, value) do
    # Statix.set(key, value)
  end

  def collect(:gauge, key, value) do
    event_name = :erlang.iolist_to_binary(key)
    :telemetry.execute(event_name, %{value: value})
  end

  def collect(:timing, key, value) do
    # Statix.timing(key, value)
  end

  # Add new metrics here
  def metrics() do
    # Gauge stats
    last_value("vmstats.proc_count.value")
    last_value("vmstats.proc_limit.value")
    last_value("vmstats.port_count.value")
    last_value("vmstats.port_limit.value")
    last_value("vmstats.atom_count.value")
    last_value("vmstats.messages_in_queues.value")
    last_value("vmstats.modules.value")
    last_value("vmstats.run_queue.value")
    last_value("vmstats.memory.total.value")
    last_value("vmstats.memory.procs_used.value")
    last_value("vmstats.memory.atom_used.value")
    last_value("vmstats.memory.binary.value")
    last_value("vmstats.memory.ets.value")
  end
end
