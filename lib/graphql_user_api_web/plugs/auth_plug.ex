defmodule GraphqlUserApiWeb.AuthPlug do
  @behaviour Plug

  import Plug.Conn

  @impl true
  def init(opts), do: opts

  @impl true
  def call(conn, _opts) do
    case get_api_key(conn) do
      {:error, _} ->
        conn

      {:ok, api_key} ->
        Absinthe.Plug.put_options(conn, context: %{api_key: api_key})
    end
  end

  def get_api_key(conn) do
    case get_req_header(conn, "api_key") do
      [api_key] ->
        {:ok, api_key}

      _ ->
        {:error, :no_api_key}
    end
  end
end
