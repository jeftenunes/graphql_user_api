defmodule GraphqlUserApi.Repo do
  use Ecto.Repo,
    otp_app: :graphql_user_api,
    adapter: Ecto.Adapters.Postgres
end
