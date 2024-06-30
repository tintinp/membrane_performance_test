defmodule Membrane.Monitoring.ReconProcessMonitoring do
  @interval Application.compile_env(
              :membrane_performance_test,
              [:process_monitoring, :interval],
              3000
            )

  defmacro __using__(_opts) do
    quote do
      def handle_info(:collect_process_info, _ctx, state) do
        Monitoring.ReconMetrics.monitor_process_info(self(), %{group: state.group, id: state.id})

        __MODULE__.collect_process_info()
        {[], state}
      end

      def collect_process_info() do
        Process.send_after(self(), :collect_process_info, unquote(@interval))
      end
    end
  end
end
