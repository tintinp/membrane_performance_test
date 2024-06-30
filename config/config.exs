import Config

config :membrane_core,
  unsafely_name_processes_for_observer: [:components]

# config :logger, :console, format: "[$level] $message\n", level: :info

config :vmstats,
  sink: Monitoring.VMStatsSink,
  interval: 3000

config :membrane_performance_test, :vm_monitoring, interval: 3000
config :membrane_performance_test, :process_monitoring, interval: 3000
