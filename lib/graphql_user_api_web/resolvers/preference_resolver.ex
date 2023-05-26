defmodule GraphqlUserApiWeb.Resolvers.PreferenceResolver do
  alias GraphqlUserApi.Accounts
  use Absinthe.Schema.Notation

  def update(params, _) do
    user_id = String.to_integer(params.user_id)

    Accounts.update_user_preferences(user_id, params)
  end
end
