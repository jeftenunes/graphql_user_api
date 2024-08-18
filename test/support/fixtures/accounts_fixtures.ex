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

  def find_non_existent_user_id(exclude_ids) do
    id = Enum.random(0..List.first(exclude_ids))

    if id not in exclude_ids do
      id
    else
      find_non_existent_user_id(exclude_ids)
    end
  end
end
