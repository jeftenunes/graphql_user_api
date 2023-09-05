defmodule GraphqlUserApiWeb.SubscriptionCase do
  require Phoenix.ChannelTest
  use ExUnit.CaseTemplate

  using do
    quote do
      use GraphqlUserApiWeb.ChannelCase

      use Absinthe.Phoenix.SubscriptionTest,
        schema: GraphqlUserApiWeb.Schema

      setup do
        {:ok, socket} =
          Phoenix.ChannelTest.connect(GraphqlUserApiWeb.Channels.UsersSocket, %{})

        {:ok, socket} = Absinthe.Phoenix.SubscriptionTest.join_absinthe(socket)

        {:ok, %{socket: socket}}
      end
    end
  end
end
