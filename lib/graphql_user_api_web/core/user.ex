defmodule GraphqlUserApiWeb.Core.User do
  alias GraphqlUserApiWeb.Repo.Boundary.DataServer

  def new(id, %{name: name, email: email, preferences: preferences}) do
    already_exists = get_by(id) !== nil
    insert_entry(already_exists, %{id: id, name: name, email: email, preferences: preferences})
  end

  def update(id, %{name: _, email: _} = new_value) do
    existing_user = get_by(id)
    update_entry(existing_user, new_value)
  end

  def update_user_preferences(
        user_id,
        %{
          likes_faxes: _likes_faxes,
          likes_emails: _likes_emails,
          likes_phone_calls: _likes_phone_calls
        } = preferences
      ) do
    user = get_by(user_id)
    update_user_preferences_entries(user, preferences)
  end

  defp insert_entry(true, _), do: {:error, "user already exists"}
  defp insert_entry(false, user), do: DataServer.put(user)

  defp update_entry(nil, _),
    do: {:error, "user does not exist"}

  defp update_entry(existing_user, new_value) do
    user = Map.merge(existing_user, new_value)
    DataServer.put(user)
  end

  defp update_user_preferences_entries(nil, _), do: {:error, "user does not exist"}

  defp update_user_preferences_entries(existing_user, preferences) do
    new_value = %{existing_user | preferences: Map.merge(existing_user.preferences, preferences)}
    update_entry(existing_user, new_value)
  end

  def get_by(id),
    do: DataServer.get_by(id)

  def get_all,
    do: DataServer.get_all()
end
