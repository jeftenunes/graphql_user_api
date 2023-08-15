defmodule GraphqlUserApiWeb.Resolvers.HitCountResolver do
  alias GraphqlUserApi.ResolverHits
  use Absinthe.Schema.Notation

  def get_resolver_hit_count(key, _) do
    ResolverHits.get_resolver_hit_count(key)
  end
end
