defmodule GraphqlUserApiWeb.Schema.Mutations.Preferences do
  alias GraphqlUserApiWeb.Resolvers.PreferenceResolver
  use Absinthe.Schema.Notation

  object :preferences_mutations do
    field :update_user_preferences, :preference do
      arg(:user_id, non_null(:id))

      arg(:likes_faxes, :boolean)
      arg(:likes_emails, :boolean)
      arg(:likes_phone_calls, non_null(:boolean))

      resolve(&PreferenceResolver.update/2)
    end
  end
end
