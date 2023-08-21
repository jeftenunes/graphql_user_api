defmodule GraphqlUserApi.ResolverHits.Store do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def get_hits(resolver) do
    case Agent.get(__MODULE__, fn state -> Map.get(state, resolver) end) do
      nil -> {:ok, 0}
      hits_count -> {:ok, hits_count}
    end
  end

  def increment_hits_for(resolver) do
    case Agent.get(__MODULE__, fn state -> Map.get(state, resolver) end) do
      nil ->
        Agent.update(__MODULE__, fn state -> Map.put(state, resolver, 1) end)

      actual_hits_no ->
        Agent.update(__MODULE__, fn state -> Map.put(state, resolver, actual_hits_no + 1) end)
    end

    {:ok, :noreply}
  end
end
