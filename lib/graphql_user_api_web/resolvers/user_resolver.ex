defmodule GraphqlUserApiWeb.Resolvers.UserResolver do
  alias GraphqlUserApiWeb.Core.User
  use Absinthe.Schema.Notation

  def create_user(%{id: id, name: name, email: email, preferences: preferences} = _params, _) do
    result =
      User.new(String.to_integer(id), %{name: name, email: email, preferences: preferences})

    case result do
      {:error, message} -> {:error, message}
      result -> {:ok, result}
    end
  end

  def update_user(%{id: id, name: name, email: email} = _params, _) do
    result = User.update(String.to_integer(id), %{name: name, email: email})

    case result do
      {:error, message} -> {:error, message}
      result -> {:ok, result}
    end
  end

  def get_user_by(%{id: id} = _params, _) do
    found = User.get_by(String.to_integer(id))
    {:ok, found}
  end

  def get_all(params, _) do
    users = User.get_all()

    filtered =
      users
      |> filter(:likes_faxes, Map.get(params, :likes_faxes))
      |> filter(:likes_emails, Map.get(params, :likes_emails))
      |> filter(:likes_phone_calls, Map.get(params, :likes_phone_calls))
      |> Enum.map(fn usr -> usr end)

    {:ok, filtered}
  end

  defp filter(users, _, filter_value) when is_nil(filter_value), do: users

  defp filter(users, :likes_faxes, filter_value) do
    Stream.filter(users, fn usr ->
      usr.preferences.likes_faxes === filter_value
    end)
  end

  defp filter(users, :likes_emails, filter_value) do
    Stream.filter(users, fn usr -> usr.preferences.likes_emails === filter_value end)
  end

  defp filter(users, :likes_phone_calls, filter_value) do
    Stream.filter(users, fn usr ->
      usr.preferences.likes_phone_calls === filter_value
    end)
  end
end
