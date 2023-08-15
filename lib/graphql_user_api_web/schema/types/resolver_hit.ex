defmodule GraphqlUserApiWeb.Schema.Types.ResolverHit do
  use Absinthe.Schema.Notation

  object :resolver_hit do
    field :hits_count, :integer
  end
end
