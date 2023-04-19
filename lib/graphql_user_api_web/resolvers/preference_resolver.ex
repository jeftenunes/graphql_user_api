defmodule GraphqlUserApiWeb.Resolvers.PreferenceResolver do
  alias GraphqlUserApiWeb.Core.User
  use Absinthe.Schema.Notation

  def update(params, _) do
    user_id = String.to_integer(params.user_id)

    preferences = %{
      likes_faxes: params.likes_faxes,
      likes_emails: params.likes_emails,
      likes_phone_calls: params.likes_phone_calls
    }

    updated = User.update_user_preferences(user_id, preferences)

    res =
      case updated do
        {:error, message} -> {:error, message}
        result -> {:ok, Map.put(result.preferences, :user_id, user_id)}
      end

    res
  end
end
