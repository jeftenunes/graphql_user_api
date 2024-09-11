defmodule GraphqlUserApi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false

  alias GraphqlUserApi.Accounts.{User, Preference}

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
    |> unique_constraint(:email)
    |> cast_assoc(:preferences)
  end

  def all_users_by(params \\ %{}) do
    qry =
      from(u in User,
        left_join: p in Preference,
        on: u.id == p.user_id,
        select: u
      )

    Enum.reduce(params, qry, fn {field, val}, q ->
      where(q, [u, p], field(p, ^field) == ^val)
    end)
  end
end
