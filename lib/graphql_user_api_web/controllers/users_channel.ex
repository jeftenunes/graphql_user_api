defmodule GraphqlUserApiWeb.UsersChannel do
  use GraphqlUserApiWeb, :channel

  def join("user_created", _payload, socket) do
    {:ok, socket}
  end

  def handle_in(_, socket) do
    broadcast(socket, "user_created", nil)
    {:reply, socket, %{"accepted" => true}}
  end
end
