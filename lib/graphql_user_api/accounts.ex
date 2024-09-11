defmodule GraphqlUserApi.Accounts do
  @moduledoc """
  The Accounts context.
  """

  alias EctoShorts.Actions
  alias GraphqlUserApi.Repo
  alias GraphqlUserApiWeb.Schema.Types.Preference
  alias GraphqlUserApi.Accounts.{User, Preference}

  def new_user(%{name: _name, email: _email, preferences: _preferences} = params) do
    with {:ok, created} <- Actions.create(User, params) do
      {:ok, created}
    end
  end

  def find_user_by(user_id) do
    Actions.find(User, %{id: user_id})
  end

  def all_users(params \\ %{}) do
    {:ok, User.all_users_by(params) |> Repo.all()}
  end

  def update_user_preferences(user_id, preferences) do
    Actions.find_and_update(Preference, %{user_id: user_id}, preferences)
  end

  def update_user(id, %{name: _name, email: _email} = params) do
    Actions.find_and_update(User, %{id: id, preload: :preferences}, params)
  end
end
