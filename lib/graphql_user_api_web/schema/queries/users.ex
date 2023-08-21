defmodule GraphqlUserApiWeb.Schema.Queries.Users do
  alias GraphqlUserApiWeb.Resolvers.UserResolver
  use Absinthe.Schema.Notation

  object :users_queries do
    field :user, :user do
      arg(:id, non_null(:id))

      resolve(&UserResolver.get_user_by/2)
    end

    field :users, list_of(:user) do
      arg(:likes_faxes, :boolean)
      arg(:likes_emails, :boolean)
      arg(:likes_phone_calls, :boolean)

      resolve(&UserResolver.get_all/2)
    end
  end
end
