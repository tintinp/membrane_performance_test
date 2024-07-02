defmodule MembranePerformanceTest.Monitoring.VMStatsTelemetryConnector do
  import Telemetry.Metrics

  defmacro __using__(opts) do
    quote do
      @vmstats_event_to_atom MembranePerformanceTest.Monitoring.VMStatsTelemetryConnector.__create_event_to_atom_map__(
                               unquote(opts)
                             )

      def metrics() do
        MembranePerformanceTest.Monitoring.VMStatsTelemetryConnector.__create_telemetry_functions__(
          unquote(opts)
        )
      end
    end
  end

  def __create_event_to_atom_map__(opts) do
    {gauge_events, opts} = Keyword.pop(opts, :gauge_events)
    {counter_events, opts} = Keyword.pop(opts, :counter_events)
    {timing_events, opts} = Keyword.pop(opts, :timing_events)

    if opts != [] do
      IO.warn("unknown options given to Monitoring.VMStatsTelemetryConnector: #{inspect(opts)}")
    end

    map_entries =
      Enum.map(gauge_events ++ counter_events ++ timing_events, fn string ->
        parts = String.split(string, ".")
        atoms = Enum.map(parts, &String.to_atom/1)
        {string, atoms}
      end)

    Enum.into(map_entries, %{})
  end

  def __create_telemetry_functions__(opts) do
    {gauge_events, opts} = Keyword.pop(opts, :gauge_events)
    {counter_events, opts} = Keyword.pop(opts, :counter_events)
    {timing_events, opts} = Keyword.pop(opts, :timing_events)

    if opts != [] do
      IO.warn("unknown options given to Monitoring.VMStatsTelemetryConnector: #{inspect(opts)}")
    end

    gauge_fn_list =
      Enum.map(gauge_events, fn event ->
        last_value("#{event}.value")
      end)

    counter_fn_list =
      Enum.map(counter_events, fn event ->
        counter("#{event}.value")
      end)

    timing_fn_list =
      Enum.map(timing_events, fn event ->
        summary("#{event}.value", unit: {:native, :millisecond})
      end)

    gauge_fn_list ++ counter_fn_list ++ timing_fn_list
  end
end
