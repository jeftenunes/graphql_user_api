defmodule GraphqlUserApiWeb.Middlewares.ResolverHitMiddleware do
  @behaviour Absinthe.Middleware

  alias GraphqlUserApi.ResolverHits

  def call(resolution, _config) do
    [{_, %{id: _id, middleware: middleware}}] = resolution.middleware
    {_, f} = List.first(middleware)

    ResolverHits.hit_resolver(to_string(Function.info(f)[:name]))

    resolution
  end
end
