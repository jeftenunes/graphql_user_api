defmodule GraphqlUserApiWeb.Schema.Queries.ResolverHits do
  alias GraphqlUserApiWeb.Resolvers.HitCountResolver
  use Absinthe.Schema.Notation

  object :resolver_hits_query do
    field :resolver_hits, :resolver_hit do
      arg :key, non_null(:string)

      resolve &HitCountResolver.get_resolver_hit_count/2
    end
  end
end
