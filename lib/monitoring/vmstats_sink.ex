defmodule Monitoring.VMStatsSink do
  @behaviour :vmstats_sink
  import Telemetry.Metrics

  @gauge_events [
    "vmstats.proc_count",
    "vmstats.proc_limit",
    "vmstats.port_count",
    "vmstats.port_limit",
    "vmstats.atom_count",
    "vmstats.messages_in_queues",
    "vmstats.modules",
    "vmstats.run_queue",
    "vmstats.memory.total",
    "vmstats.memory.procs_used",
    "vmstats.memory.atom_used",
    "vmstats.memory.binary",
    "vmstats.memory.ets"
  ]
  @counter_events []
  @timing_events []

  use(Monitoring.VMStatsTelemetryConnector, @gauge_events, @counter_events, @timing_events)

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
end
