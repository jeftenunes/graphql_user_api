defmodule GraphqlUserApiWeb.Middlewares.ResolverHitMiddleware do
  @behaviour Absinthe.Middleware

  alias GraphqlUserApi.ResolverHits

  @impl true
  def call(resolution, _config) do
    case resolution.middleware do
      [{_, %{id: _id, middleware: middleware}}] ->
        {_, f} = List.first(middleware)

        ResolverHits.hit_resolver(to_string(Function.info(f)[:name]))

        resolution

      [] ->
        resolution
    end
  end
end
