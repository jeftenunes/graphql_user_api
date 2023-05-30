defmodule GraphqlUserApi.Accounts.Preference do
  use Ecto.Schema
  import Ecto.Changeset

  schema "preferences" do
    field(:likes_emails, :boolean, default: false)
    field(:likes_faxes, :boolean, default: false)
    field(:likes_phone_calls, :boolean, default: false)

    belongs_to(:user, GraphqlUserApi.Accounts.User)
  end

  @available_fields [:likes_emails, :likes_faxes, :likes_phone_calls]

  @doc false
  def changeset(preference, attrs) do
    preference
    |> cast(attrs, @available_fields)
    |> validate_required(@available_fields)
  end
end
