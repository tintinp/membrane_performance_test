defmodule MembranePerformanceTestApplication do
  use Application
  import Telemetry.Metrics

  @impl true
  def start(_type, _args) do
    children = [
      {TelemetryMetricsStatsd, metrics: metrics()},
      {Foo, name: Foo}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MembranePerformanceTestApplication.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp metrics() do
    [
      last_value("my_app.foo.value", tags: [:from, :operation])
    ]
  end
end
