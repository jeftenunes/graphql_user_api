defmodule GraphqlUserApi.Hits do
  alias GraphqlUserApi.Hits.Store

  def get_resolver_hit_count(resolver),
    do: Store.get_hits(resolver)

  def hit_resolver(resolver),
    do: Store.increment_hits_for(resolver)
end
