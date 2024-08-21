defmodule GraphqlUserApiWeb.Schema.Mutations.Users do
  use Absinthe.Schema.Notation

  alias GraphqlUserApiWeb.Resolvers.UserResolver
  alias GraphqlUserApiWeb.Middlewares.AuthMiddleware

  object :users_mutations do
    field :create_user, :user do
      arg :name, :string
      arg :email, :string
      arg :preferences, non_null(:preference_input)

      # in real life, one stores the api_key at a key vault, uses env vars and does a replace in deploy time
      middleware AuthMiddleware, api_key: "api_key"
      resolve &UserResolver.create_user/2
    end

    field :update_user, :user do
      arg :name, :string
      arg :id, non_null(:id)
      arg :email, non_null(:string)

      middleware AuthMiddleware, api_key: "api_key"
      resolve &UserResolver.update_user/2
    end
  end
end
