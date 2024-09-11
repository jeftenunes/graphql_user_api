defmodule GraphqlUserApiWeb.Schema.Subscriptions.Users do
  use Absinthe.Schema.Notation

  object :users_subscriptions do
    field :created_user, :user do
      arg :user_id, :id

      trigger :create_user,
        topic: fn _ ->
          "user_created"
        end

      config fn _, _ -> {:ok, topic: "user_created"} end
    end
  end
end
