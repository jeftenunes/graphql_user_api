defmodule GraphqlUserApiWeb.Middlewares.ResolverHitMiddleware do
  @behaviour Absinthe.Middleware

  alias GraphqlUserApi.ResolverHits

  @impl true
  def call(resolution, _config) do
    case resolution.middleware do
      [{_, %{id: _id, middleware: middleware}}] ->
        f = extract_fun(middleware)

        ResolverHits.hit_resolver(to_string(Function.info(f)[:name]))

        resolution

      [] ->
        resolution
    end
  end

  defp extract_fun([_auth, {{Absinthe.Resolution, :call}, f} | _rest] = _middleware), do: f
  defp extract_fun([{{Absinthe.Resolution, :call}, f} | _rest] = _middleware), do: f
end
