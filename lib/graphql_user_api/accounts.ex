defmodule GraphqlUserApi.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias GraphqlUserApiWeb.Schema.Types.Preference
  alias GraphqlUserApi.Accounts.{User, Preference}
  alias EctoShorts.Actions

  def new_user(%{name: _name, email: _email, preferences: _preferences} = params) do
    Actions.create(User, params)
  end

  def find_user_by(user_id) do
    Actions.find(User, %{id: user_id})
  end

  def all_users(params \\ %{}) do
    {:ok, Actions.all(User, params)}
  end

  def update_user_preferences(user_id, preferences) do
    op_result = Actions.find_and_update(Preference, %{user_id: user_id}, preferences)

    case op_result do
      {:error, _} -> {:error, "preferences not found"}
      {:ok, result} -> {:ok, result}
    end
  end

  def update_user(id, %{name: _name, email: _email} = params) do
    Actions.find_and_update(User, %{id: id, preload: :preferences}, params)
  end
end
