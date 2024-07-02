defmodule MembranePerformanceTestApplication do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # {Plug.Cowboy, scheme: :http, plug: Monitoring.Router, options: [port: cowboy_port()]},
      MembranePerformanceTest.Membrane.PromEx,
      # {TelemetryMetricsStatsd,
      #  metrics:
      #    MembranePerformanceTest.Monitoring.VMStatsSink.metrics() ++
      #      Monitoring.ReconMetrics.metrics() ++ Monitoring.BufferMetricEmitter.metrics()},
      {Task.Supervisor, name: ReconMonitoring.TaskSupervisor},
      # {Monitoring.ReconVmMonitoring, name: Monitoring.ReconVmMonitoring},
      # MembranePerformanceTest.Membrane.Pipeline.Simple
      {MembranePerformanceTest.Membrane.Pipeline.Series,
       %{series_count: 1000, source_push_interval: 12, buffer_size: floor(4.5 * 1024)}}
      # {MembranePerformanceTest.Membrane.Pipeline.Parallel,
      #  %{parallel_count: 10, source_push_interval: 12, buffer_size: floor(4.5 * 1024)}}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MembranePerformanceTestApplication.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # defp cowboy_port, do: Application.get_env(:membrane_performance_test, :cowboy_port, 4000)
end
