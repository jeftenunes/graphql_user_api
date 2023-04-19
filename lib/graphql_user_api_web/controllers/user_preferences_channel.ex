defmodule GraphqlUserApiWeb.UserPreferencesChannel do
  use GraphqlUserApiWeb, :channel

  def join("preferences_updated", _payload, socket) do
    {:ok, socket}
  end

  def handle_in(_, socket) do
    broadcast(socket, "preferences_updated", nil)
    {:reply, socket, %{"accepted" => true}}
  end
end
