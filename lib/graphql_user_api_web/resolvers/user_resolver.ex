defmodule GraphqlUserApiWeb.Resolvers.UserResolver do
  alias GraphqlUserApi.Hits
  alias GraphqlUserApi.Accounts

  use Absinthe.Schema.Notation

  def create_user(%{name: name, email: email, preferences: preferences} = _params, _) do
    Hits.hit_resolver("create_user")
    Accounts.new_user(%{name: name, email: email, preferences: preferences})
  end

  def update_user(%{id: id, name: name, email: email} = _params, _) do
    Hits.hit_resolver("update_user")
    Accounts.update_user(String.to_integer(id), %{name: name, email: email})
   end

  def get_user_by(%{id: id} = _params, _) do
    Hits.hit_resolver("get_user_by")
    Accounts.find_user_by(String.to_integer(id))
  end

  def get_all(params, _) do
    Hits.hit_resolver("get_all")
    Accounts.all_users(params)
  end
end
