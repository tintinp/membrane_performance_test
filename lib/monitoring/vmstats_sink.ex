defmodule Monitoring.VMStatsSink do
  @behaviour :vmstats_sink

  @gauge_events [
    "vmstats.proc_count",
    "vmstats.proc_limit",
    "vmstats.port_count",
    "vmstats.port_limit",
    "vmstats.atom_count",
    "vmstats.messages_in_queues",
    "vmstats.modules",
    "vmstats.run_queue",

    # These are counter events but need to investigate how to use it properly with statsd.
    # Counter in statsd increments by value of 1, but the value from these metrics seems to be in bytes.
    "vmstats.memory.total",
    "vmstats.memory.procs_used",
    "vmstats.memory.atom_used",
    "vmstats.memory.binary",
    "vmstats.memory.ets",
    "vmstats.io.bytes_in",
    "vmstats.io.bytes_out",
    "vmstats.gc.count",
    "vmstats.gc.words_reclaimed",
    "vmstats.reductions"
  ]

  use Monitoring.VMStatsTelemetryConnector,
    gauge_events: @gauge_events,
    counter_events: [],
    timing_events: []

  def collect(:counter, key, value) do
    event_name = :erlang.iolist_to_binary(key)
    :telemetry.execute(@vmstats_event_to_atom[event_name], %{value: value})
  end

  def collect(:gauge, key, value) do
    event_name = :erlang.iolist_to_binary(key)
    :telemetry.execute(@vmstats_event_to_atom[event_name], %{value: value})
  end

  def collect(:timing, _key, _value) do
    # Ignoring this for now, metrics are
    # "vmstats.vm_uptime"
    # "vmstats.scheduler_wall_time.<n>.active" where n is a number
    # "vmstats.scheduler_wall_time.<n>.total" where n is a number

    # event_name = :erlang.iolist_to_binary(key)
    # :telemetry.execute(@vmstats_event_to_atom[event_name], %{value: value})
  end
end
