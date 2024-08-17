defmodule GraphqlUserApiWeb.Schema.Mutations.Users do
  alias GraphqlUserApiWeb.Resolvers.UserResolver
  use Absinthe.Schema.Notation

  object :users_mutations do
    field :create_user, :user do
      arg(:name, :string)
      arg(:email, :string)
      arg(:preferences, non_null(:preference_input))

      resolve(&UserResolver.create_user/2)
    end

    field :update_user, :user do
      arg(:name, :string)
      arg(:id, non_null(:id))
      arg(:email, non_null(:string))

      resolve(&UserResolver.update_user/2)
    end
  end
end
