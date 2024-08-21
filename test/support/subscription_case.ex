defmodule GraphqlUserApiWeb.SubscriptionCase do
  use ExUnit.CaseTemplate

  alias Phoenix.ChannelTest

  using do
    quote do
      use GraphqlUserApiWeb.ChannelCase

      use Absinthe.Phoenix.SubscriptionTest,
        schema: GraphqlUserApiWeb.Schema

      setup do
        {:ok, socket} =
          Phoenix.ChannelTest.connect(GraphqlUserApiWeb.Channels.UsersSocket, %{
            "api_key" => "api_key"
          })

        {:ok, socket} = Absinthe.Phoenix.SubscriptionTest.join_absinthe(socket)

        {:ok, %{socket: socket}}
      end
    end
  end
end
