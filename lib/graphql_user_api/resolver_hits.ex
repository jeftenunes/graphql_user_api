defmodule GraphqlUserApi.ResolverHits do
  alias GraphqlUserApi.ResolverHits.Store

  def get_resolver_hit_count(%{key: key} = _) do
    hits_count = Store.get_hits(key)

    {:ok, %{:hits_count => hits_count}}
  end

  defdelegate hit_resolver(resolver_name), to: Store, as: :increment_hits_for
end
