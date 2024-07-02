defmodule MembranePerformanceTestApplication do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {TelemetryMetricsStatsd,
       metrics:
         Monitoring.VMStatsSink.metrics() ++
           Monitoring.ReconMetrics.metrics() ++ Monitoring.BufferMetricEmitter.metrics()},
      {Task.Supervisor, name: ReconMonitoring.TaskSupervisor},
      {Monitoring.ReconVmMonitoring, name: Monitoring.ReconVmMonitoring},
      # Membrane.Pipeline.Simple
      # {Membrane.Pipeline.Series, %{filter_count: 100}}
      {Membrane.Pipeline.Parallel,
       %{parallel_count: 10, source_push_interval: 12, buffer_size: floor(4.5 * 1024)}}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MembranePerformanceTestApplication.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
