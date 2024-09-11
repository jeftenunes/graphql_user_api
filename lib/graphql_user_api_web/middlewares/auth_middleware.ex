defmodule GraphqlUserApiWeb.Middlewares.AuthMiddleware do
  @behaviour Absinthe.Middleware

  @impl true
  def call(%{context: %{api_key: api_key}} = resolution, config) do
    if config[:api_key] === api_key do
      resolution
    else
      Absinthe.Resolution.put_result(resolution, {:error, "not authorized"})
    end
  end

  @impl true
  def call(resolution, _config) do
    Absinthe.Resolution.put_result(resolution, {:error, "not authorized"})
  end
end
