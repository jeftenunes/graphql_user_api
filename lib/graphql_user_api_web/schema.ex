defmodule GraphqlUserApiWeb.Schema do
  alias GraphqlUserApiWeb.Middlewares.ResolverHitMiddleware
  use Absinthe.Schema

  import_types(GraphqlUserApiWeb.Schema.Types.User)
  import_types(GraphqlUserApiWeb.Schema.Types.Preference)
  import_types(GraphqlUserApiWeb.Schema.Types.ResolverHit)
  import_types(GraphqlUserApiWeb.Schema.Queries.Users)
  import_types(GraphqlUserApiWeb.Schema.Mutations.Users)
  import_types(GraphqlUserApiWeb.Schema.Mutations.Preferences)
  import_types(GraphqlUserApiWeb.Schema.Subscriptions.Users)
  import_types(GraphqlUserApiWeb.Schema.Subscriptions.Preferences)
  import_types(GraphqlUserApiWeb.Schema.Queries.ResolverHits)

  @desc "Retrieves users/resolver hit counts"
  query do
    import_fields(:users_queries)
    import_fields(:resolver_hits_query)
  end

  @desc "Mutates users"
  mutation do
    import_fields(:users_mutations)
    import_fields(:preferences_mutations)
  end

  subscription do
    import_fields(:users_subscriptions)
    import_fields(:preferences_subscriptions)
  end

  def context(ctx) do
    source = Dataloader.Ecto.new(GraphqlUserApi.Repo)
    dataloader = Dataloader.add_source(Dataloader.new(), GraphqlUserApi.Accounts, source)
    Map.put(ctx, :loader, dataloader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  def middleware(middleware, _field, %Absinthe.Type.Object{identifier: identifier})
    when identifier in [:query, :subscription, :mutation] do
      middleware ++ [ResolverHitMiddleware]
  end

  def middleware(middleware, _field, _object) do
    middleware
  end
end
