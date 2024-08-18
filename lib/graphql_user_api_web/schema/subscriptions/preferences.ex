defmodule GraphqlUserApiWeb.Schema.Subscriptions.Preferences do
  use Absinthe.Schema.Notation

  object :preferences_subscriptions do
    field :updated_user_preferences, :preference do
      arg :user_id, :id

      trigger :update_user_preferences,
        topic: fn args ->
          "preferences_updated_#{args.user_id}"
        end

      config fn args, _ -> {:ok, topic: "preferences_updated_#{args.user_id}"} end
    end
  end
end
