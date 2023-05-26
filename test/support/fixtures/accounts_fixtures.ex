defmodule GraphqlUserApi.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GraphqlUserApi.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        name: "some name"
      })
      |> GraphqlUserApi.Accounts.create_user()

    user
  end

  @doc """
  Generate a preference.
  """
  def preference_fixture(attrs \\ %{}) do
    {:ok, preference} =
      attrs
      |> Enum.into(%{
        likes_emails: true,
        likes_faxes: true,
        likes_phone_calls: true
      })
      |> GraphqlUserApi.Accounts.create_preference()

    preference
  end
end
