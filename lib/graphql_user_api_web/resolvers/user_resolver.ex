defmodule GraphqlUserApiWeb.Resolvers.UserResolver do
  alias GraphqlUserApi.Accounts
  use Absinthe.Schema.Notation

  def create_user(%{name: name, email: email, preferences: preferences} = _params, _) do
    Accounts.new_user(%{name: name, email: email, preferences: preferences})
  end

  def update_user(%{id: id, name: name, email: email} = _params, _),
    do: Accounts.update_user(String.to_integer(id), %{name: name, email: email})

  def get_user_by(%{id: id} = _params, _), do: Accounts.find_user_by(String.to_integer(id))

  def get_all(params, _), do: Accounts.all_users(params)
end
