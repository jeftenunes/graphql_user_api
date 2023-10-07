defmodule GraphqlUserApi.ResolverHits.Store do
  use Agent

  @default_name ResolverHitsStore

  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :name, @default_name)
    Agent.start_link(fn -> %{} end, opts)
  end

  def get_hits(agent \\ @default_name, resolver) do
    Agent.get(agent, &Map.get(&1, resolver, 0))
  end

  def increment_hits_for(agent \\ @default_name, resolver) do
    Agent.update(agent, fn state ->
      case Map.get(state, resolver) do
        nil -> Map.put(state, resolver, 1)
        count_hit -> Map.put(state, resolver, count_hit + 1)
      end
    end)
  end
end
