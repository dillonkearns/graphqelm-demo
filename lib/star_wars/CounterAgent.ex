defmodule StarWars.CounterAgent do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> 0 end, name: __MODULE__)
  end

  def increment() do
    Agent.get_and_update(__MODULE__, fn(n) -> {n + 1, n + 1} end)
  end
end
