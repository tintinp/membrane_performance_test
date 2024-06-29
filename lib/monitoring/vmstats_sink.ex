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
  @counter_events [
    "vmstats.io.bytes_in",
    "vmstats.io.bytes_out",
    "vmstats.gc.count",
    "vmstats.gc.words_reclaimed",
    "vmstats.reductions"
  ]
  @timing_events [
    "vmstats.vm_uptime",
    "vmstats.scheduler_wall_time.1.active",
    "vmstats.scheduler_wall_time.1.total",
    "vmstats.scheduler_wall_time.2.active",
    "vmstats.scheduler_wall_time.2.total",
    "vmstats.scheduler_wall_time.3.active",
    "vmstats.scheduler_wall_time.3.total",
    "vmstats.scheduler_wall_time.4.active",
    "vmstats.scheduler_wall_time.4.total",
    "vmstats.scheduler_wall_time.5.active",
    "vmstats.scheduler_wall_time.5.total",
    "vmstats.scheduler_wall_time.6.active",
    "vmstats.scheduler_wall_time.6.total",
    "vmstats.scheduler_wall_time.7.active",
    "vmstats.scheduler_wall_time.7.total",
    "vmstats.scheduler_wall_time.8.active",
    "vmstats.scheduler_wall_time.8.total",
    "vmstats.scheduler_wall_time.9.active",
    "vmstats.scheduler_wall_time.9.total",
    "vmstats.scheduler_wall_time.10.active",
    "vmstats.scheduler_wall_time.10.total",
    "vmstats.scheduler_wall_time.11.active",
    "vmstats.scheduler_wall_time.11.total",
    "vmstats.scheduler_wall_time.12.active",
    "vmstats.scheduler_wall_time.12.total",
    "vmstats.scheduler_wall_time.13.active",
    "vmstats.scheduler_wall_time.13.total",
    "vmstats.scheduler_wall_time.14.active",
    "vmstats.scheduler_wall_time.14.total",
    "vmstats.scheduler_wall_time.15.active",
    "vmstats.scheduler_wall_time.15.total",
    "vmstats.scheduler_wall_time.16.active",
    "vmstats.scheduler_wall_time.16.total"
  ]

  use Monitoring.VMStatsTelemetryConnector,
    gauge_events: @gauge_events,
    counter_events: @counter_events,
    timing_events: @timing_events

  def collect(:counter, key, value) do
    event_name = :erlang.iolist_to_binary(key)
    :telemetry.execute(@vmstats_event_to_atom[event_name], %{value: value})
  end

  def collect(:gauge, key, value) do
    event_name = :erlang.iolist_to_binary(key)
    :telemetry.execute(@vmstats_event_to_atom[event_name], %{value: value})
  end

  def collect(:timing, key, value) do
    IO.inspect(key)
    IO.inspect(value)
    event_name = :erlang.iolist_to_binary(key)
    :telemetry.execute(@vmstats_event_to_atom[event_name], %{value: value})
  end
end
