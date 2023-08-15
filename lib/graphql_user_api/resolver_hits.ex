defmodule GraphqlUserApi.ResolverHits do
  alias GraphqlUserApi.ResolverHits.Store

  def get_resolver_hit_count(%{key: key} = _) do
    {:ok, hits_count} = Store.get_hits(key)
    {:ok, %{:hits_count => hits_count}}
  end

  def hit_resolver(resolver_name),
    do: Store.increment_hits_for(resolver_name)
end
