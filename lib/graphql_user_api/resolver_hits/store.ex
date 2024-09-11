defmodule GraphqlUserApi.ResolverHits.Store do
  use GenServer

  def start_link(_opts \\ []) do
    GenServer.start_link(GraphqlUserApi.ResolverHits.Store, :no_state,
      name: GraphqlUserApi.ResolverHits.Store
    )
  end

  @impl true
  def init(_) do
    {:ok, :no_state}
  end

  def get_hits(resolver) do
    case ConCache.get(:resolver_hits_store, resolver) do
      nil -> 0
      value -> value
    end
  end

  def increment_hits_for(resolver) do
    hit_count = get_hits(resolver)
    ConCache.put(:resolver_hits_store, resolver, hit_count + 1)
  end
end
