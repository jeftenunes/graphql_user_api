defmodule GraphqlUserApiWeb.Schema.Queries.Users do
  use Absinthe.Schema.Notation

  alias GraphqlUserApiWeb.Resolvers.UserResolver
  alias GraphqlUserApiWeb.Middlewares.ChangesetMiddleware

  object :users_queries do
    field :user, :user do
      arg :id, non_null(:id)

      resolve &UserResolver.get_user_by/2
      middleware ChangesetMiddleware
    end

    field :users, list_of(:user) do
      arg :likes_faxes, :boolean
      arg :likes_emails, :boolean
      arg :likes_phone_calls, :boolean

      resolve &UserResolver.get_all/2
      middleware ChangesetMiddleware
    end
  end
end
