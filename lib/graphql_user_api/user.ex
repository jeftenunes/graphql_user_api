defmodule GraphqlUserApi.User do
  alias GraphqlUserApiWeb.Data.DataServer

  def new(id, %{name: name, email: email, preferences: preferences}) do
    insert_entry(user_exists?(id), %{id: id, name: name, email: email, preferences: preferences})
  end

  def update(id, %{name: _, email: _} = new_value) do
    found = get_by(id)

    with {:ok, existing_usr} <- found do
      update_entry(existing_usr, new_value)
    end
  end

  def update_user_preferences(
        user_id,
        %{
          likes_faxes: _likes_faxes,
          likes_emails: _likes_emails,
          likes_phone_calls: _likes_phone_calls
        } = preferences
      ) do
    found = get_by(user_id)

    with {:ok, existing_usr} <- found do
      {:ok, result} = update_user_preferences_entries(existing_usr, preferences)
      {:ok, Map.put(result.preferences, :user_id, user_id)}
    end
  end

  def get_by(id) do
    case DataServer.get_by(id) do
      nil -> {:error, "user not found"}
      user -> {:ok, user}
    end
  end

  def get_all,
    do: {:ok, DataServer.get_all()}

  def get_all(preferences) do
    users = DataServer.get_all()
    {:ok, Enum.filter(users, fn usr -> filter_users_by_preferences(usr, preferences) end)}
  end

  defp user_exists?(user_id) do
    DataServer.get_by(user_id) !== nil
  end

  defp filter_users_by_preferences(user, preferences) do
    preferences
    |> Enum.map(fn {pref, val} -> user.preferences[pref] === val end)
    |> Enum.reduce(fn filter_result, acc -> acc && filter_result end)
  end

  defp insert_entry(true, _), do: {:error, "user already exists"}
  defp insert_entry(false, user), do: {:ok, DataServer.put(user)}

  defp update_entry(nil, _),
    do: {:error, "user not found"}

  defp update_entry(existing_user, new_value) do
    user = Map.merge(existing_user, new_value)
    {:ok, DataServer.put(user)}
  end

  defp update_user_preferences_entries(nil, _), do: {:error, "user does not exist"}

  defp update_user_preferences_entries(existing_user, preferences) do
    new_value = %{existing_user | preferences: Map.merge(existing_user.preferences, preferences)}
    update_entry(existing_user, new_value)
  end
end
