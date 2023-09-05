defmodule GraphqlUserApiWeb.ChannelCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      # import conveniences for testing with channels
      import Phoenix.ChannelTest

      # the default endpoint for testing
      @endpoint GraphqlUserApiWeb.Endpoint
    end
  end
end
