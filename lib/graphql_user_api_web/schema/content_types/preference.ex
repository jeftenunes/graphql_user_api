defmodule GraphqlUserApiWeb.Schema.ContentTypes.Preference do
  use Absinthe.Schema.Notation

  object :preference do
    field(:user_id, :id)
    field(:likes_faxes, :boolean)
    field(:likes_emails, :boolean)
    field(:likes_phone_calls, :boolean)
  end
end
