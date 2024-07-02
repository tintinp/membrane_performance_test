defmodule MembranePerformanceTest.Membrane.MixProject do
  use Mix.Project

  def project do
    [
      app: :membrane_performance_test,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {MembranePerformanceTestApplication, []},
      extra_applications: [:logger, :runtime_tools, :observer, :wx]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:membrane_core, "~> 1.0"},
      {:membrane_h264_ffmpeg_plugin, "~> 0.31.6"},
      {:membrane_h26x_plugin, "~> 0.10.2"},
      {:membrane_tee_plugin, "~> 0.12.0"},
      {:membrane_file_plugin, "~> 0.17.0"},
      {:membrane_fake_plugin, "~> 0.11.0"},
      {:membrane_rtp_plugin, "~> 0.28.0"},
      {:membrane_rtp_h264_plugin, "~> 0.19.1"},
      {:recon, "~> 2.5"},
      {:vmstats, "~> 2.4"},
      {:telemetry, "~> 1.0"},
      {:telemetry_metrics, "~> 1.0", override: true},
      {:telemetry_poller, "~> 1.0"},
      {:telemetry_metrics_statsd, "~> 0.6.0"},
      {:plug_cowboy, "~> 2.7"},
      {:prom_ex, "~> 1.9.0"}
    ]
  end
end
