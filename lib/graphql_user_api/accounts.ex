defmodule GraphqlUserApi.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias GraphqlUserApiWeb.Schema.Types.Preference
  alias GraphqlUserApi.Accounts.{User, Preference}
  alias GraphqlUserApi.Repo
  alias EctoShorts.Actions

  def new_user(%{name: _name, email: _email, preferences: _preferences} = params) do
    Actions.create(User, params)
  end

  def find_user_by(user_id) do
    Actions.find(User, %{id: user_id})
  end

  def all_users(params \\ %{}) do
    qry =
      from u in User,
        left_join: p in Preference,
        on: u.id == p.user_id,
        where: ^filter_where(params),
        select: %User{
          id: u.id,
          name: u.name,
          email: u.email,
          preferences: %Preference{
            id: p.id,
            likes_emails: p.likes_emails,
            likes_faxes: p.likes_faxes,
            likes_phone_calls: p.likes_phone_calls
          }
        }

    {:ok, Repo.all(qry)}
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

  defp filter_where(params) do
    Enum.reduce(params, dynamic(true), fn
      {:likes_faxes, value}, dynamic ->
        dynamic([u, p], ^dynamic and p.likes_faxes == ^value)

      {:likes_emails, value}, dynamic ->
        dynamic([u, p], ^dynamic and p.likes_emails == ^value)

      {:likes_phone_calls, value}, dynamic ->
        dynamic([u, p], ^dynamic and p.likes_phone_calls == ^value)

      {_, _}, dynamic ->
        dynamic
    end)
  end
end
