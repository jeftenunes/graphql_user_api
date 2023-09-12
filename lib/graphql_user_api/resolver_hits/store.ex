defmodule GraphqlUserApi.ResolverHits.Store do
  use Agent

  @default_name ResolverHitsStore

  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :name, @default_name)
    Agent.start_link(fn -> %{} end, opts)
  end

  def get_hits(agent \\ @default_name, resolver) do
    case Agent.get(agent, fn state -> Map.get(state, resolver) end) do
      nil -> {:ok, 0}
      hits_count -> {:ok, hits_count}
    end
  end

  def increment_hits_for(agent \\ @default_name, resolver) do
    Agent.get_and_update(agent, fn state ->
      case Map.get(state, resolver) do
        nil -> {state, Map.put(state, resolver, 1)}
        actual_hits_no -> {state, Map.put(state, resolver, actual_hits_no + 1)}
      end
    end)

    {:ok, :noreply}
  end
end
