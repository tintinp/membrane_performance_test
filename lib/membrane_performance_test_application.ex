defmodule MembranePerformanceTestApplication do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {TelemetryMetricsStatsd, metrics: Monitoring.VMStatsSink.metrics()},
      {Foo, name: Foo}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MembranePerformanceTestApplication.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
