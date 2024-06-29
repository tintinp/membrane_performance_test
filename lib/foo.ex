defmodule Foo do
  use GenServer

  def start_link(opt) do
    GenServer.start(__MODULE__, nil, opt)
  end

  def emit(server) do
    GenServer.call(server, :emit)
  end

  def init(_) do
    {:ok, %{}}
  end

  def handle_call(:emit, _from, state) do
    IO.puts("hello!")
    :telemetry.execute([:my_app, :foo], %{value: 5}, %{from: "b", operation: "1"})
    IO.puts("emitted!!")
    {:reply, :ok, state}
  end
end
