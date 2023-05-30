defmodule GraphqlUserApi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:email, :string)
    field(:name, :string)

    has_one(:preferences, GraphqlUserApi.Accounts.Preference)
  end

  @available_fields [:name, :email]

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @available_fields)
    |> validate_required(@available_fields)
    |> cast_assoc(:preferences)
  end
end
