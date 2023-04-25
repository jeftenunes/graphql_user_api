defmodule GraphqlUserApiWeb.Resolvers.PreferenceResolver do
  alias GraphqlUserApi.User
  use Absinthe.Schema.Notation

  def update(params, _) do
    user_id = String.to_integer(params.user_id)

    User.update_user_preferences(user_id, params)
  end
end
