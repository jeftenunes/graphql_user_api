defmodule GraphqlUserApiWeb.Schema.InputTypes.PreferenceInput do
  use Absinthe.Schema.Notation

  input_object :preference_input do
    field(:likes_faxes, :boolean)
    field(:likes_emails, :boolean)
    field(:likes_phone_calls, :boolean)
  end
end
