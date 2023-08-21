defmodule GraphqlUserApi.DataCase do
  use ExUnit.CaseTemplate

  alias GraphqlUserApi.AccountsFixtures

  using do
    quote do
      alias GraphqlUserApi.Repo

      import Ecto
      import Ecto.Query
      import Ecto.Changeset
      import GraphqlUserApi.DataCase
    end
  end

  setup tags do
    GraphqlUserApi.DataCase.setup_sandbox(tags)
    :ok
  end

  setup _context do
    AccountsFixtures.user_fixture([
      %{
        name: "User name 0",
        email: "user0@email.com",
        preferences: %{
          "likes_emails" => false,
          "likes_faxes" => false,
          "likes_phone_calls" => false
        }
      },
      %{
        name: "User name 1",
        email: "user1@email.com",
        preferences: %{
          "likes_emails" => false,
          "likes_faxes" => true,
          "likes_phone_calls" => false
        }
      }
    ])
  end

  def setup_sandbox(tags) do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(GraphqlUserApi.Repo)
    pid = Ecto.Adapters.SQL.Sandbox.start_owner!(GraphqlUserApi.Repo, shared: not tags[:async])
    on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)

    :ok
  end
end
