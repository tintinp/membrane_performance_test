import Config

config :membrane_core,
  unsafely_name_processes_for_observer: [:components]

config :logger, :console, format: "[$level] $message\n", level: :info

config :vmstats,
  sink: MembranePerformanceTest.Monitoring.VMStatsSink,
  interval: 3000

config :membrane_performance_test, :vm_monitoring, interval: 3000
config :membrane_performance_test, :process_monitoring, interval: 3000

config :membrane_performance_test,
  cowboy_port: 4000

config :membrane_performance_test, MembranePerformanceTest.Membrane.PromEx,
  disabled: false,
  manual_metrics_start_delay: :no_delay,
  drop_metrics_groups: [],
  grafana: [
    host: "http://localhost:3000",
    # Authenticate via Basic Auth
    username: "admin",
    password: "admin",
    # This is an optional setting and will default to `true`
    upload_dashboards_on_start: true
  ],
  metrics_server: [
    port: 4000,
    # This is an optional setting and will default to `"/metrics"`
    path: "/metrics",
    # This is an optional setting and will default to `:http`
    protocol: :http,
    # This is an optional setting and will default to `5`
    pool_size: 5,
    # This is an optional setting and will default to `[]`
    cowboy_opts: [],
    # This is an optional and will default to `:none`
    auth_strategy: :none
  ]
