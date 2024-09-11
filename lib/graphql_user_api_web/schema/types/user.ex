defmodule GraphqlUserApiWeb.Schema.Types.User do
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 2]

  object :user do
    field :id, :id
    field :name, :string
    field :email, :string
    field :preferences, :preference, resolve: dataloader(GraphqlUserApi.Accounts, :preferences)
  end
end
