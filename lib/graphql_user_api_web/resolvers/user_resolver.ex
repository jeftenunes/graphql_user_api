defmodule GraphqlUserApiWeb.Resolvers.UserResolver do
  alias GraphqlUserApi.User
  use Absinthe.Schema.Notation

  def create_user(%{id: id, name: name, email: email, preferences: preferences} = _params, _) do
    User.new(String.to_integer(id), %{name: name, email: email, preferences: preferences})
  end

  def update_user(%{id: id, name: name, email: email} = _params, _) do
    User.update(String.to_integer(id), %{name: name, email: email})
  end

  def get_user_by(%{id: id} = _params, _) do
    User.get_by(String.to_integer(id))
  end

  def get_all(params, _) do
    User.get_all(params)
  end
end
