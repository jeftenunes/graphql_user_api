defmodule GraphqlUserApiWeb.Schema do
  use Absinthe.Schema

  import_types(GraphqlUserApiWeb.Schema.ContentTypes.User)
  import_types(GraphqlUserApiWeb.Schema.ContentTypes.Preference)
  import_types(GraphqlUserApiWeb.Schema.Queries.Users)
  import_types(GraphqlUserApiWeb.Schema.Mutations.Users)
  import_types(GraphqlUserApiWeb.Schema.Mutations.Preferences)

  @desc "Retrieves users"
  query do
    import_fields(:users_queries)
  end

  @desc "Mutates users"
  mutation do
    import_fields(:users_mutations)
    import_fields(:preferences_mutations)
  end

  subscription do
    field :created_user, :user do
      arg(:user_id, :id)

      trigger(:create_user,
        topic: fn _ ->
          "user_created"
        end
      )

      config(fn _, _ -> {:ok, topic: "user_created"} end)
    end

    field :updated_user_preferences, :preference do
      arg(:user_id, :id)

      trigger(:update_user_preferences,
        topic: fn args ->
          "preferences_updated_#{args.user_id}"
        end
      )

      config(fn args, _ -> {:ok, topic: "preferences_updated_#{args.user_id}"} end)
    end
  end
end
