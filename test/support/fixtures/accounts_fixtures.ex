defmodule GraphqlUserApi.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GraphqlUserApi.Accounts` context.
  """
  alias GraphqlUserApi.Accounts

  @doc """
  Generate a user.
  """
  def user_fixture(users) do
    new_users =
      Enum.each(users, fn usr ->
        Accounts.new_user(usr)
      end)

    new_users
  end
end
