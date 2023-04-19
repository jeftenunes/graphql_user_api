defmodule GraphqlUserApiWeb.Channels.UsersSocket do
  use Phoenix.Socket
  use Absinthe.Phoenix.Socket, schema: GraphqlUserApiWeb.Schema

  channel "user_created", GraphqlUserApiWeb.UsersChannel
  channel "preferences_updated", GraphqlUserApiWeb.UserPreferencesChannel

  def connect(_params, socket, _connection_info) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
