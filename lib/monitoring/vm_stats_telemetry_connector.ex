defmodule Monitoring.VMStatsTelemetryConnector do
  import Telemetry.Metrics

  defmacro __using__(gauge, counter, timing) do
    map_entries =
      Enum.map(gauge ++ counter ++ timing, fn string ->
        parts = String.split(string, ".")
        atoms = Enum.map(parts, &String.to_atom/1)
        {string, atoms}
      end)

    map = Enum.into(map_entries, %{})

    # Generate the metrics function body
    gauge_list =
      Enum.map(gauge, fn event ->
        quote do
          last_value(unquote("#{event}.value"))
        end
      end)

    counter_list =
      Enum.map(counter, fn event ->
        quote do
          counter(unquote("#{event}.value"))
        end
      end)

    timing_list =
      Enum.map(timing, fn event ->
        quote do
          timing(unquote("#{event}.value"))
        end
      end)

    quote do
      @vmstats_event_to_atom unquote(Macro.escape(map))

      def metrics() do
        unquote(gauge_list ++ counter_list ++ timing_list)
      end
    end
  end
end
