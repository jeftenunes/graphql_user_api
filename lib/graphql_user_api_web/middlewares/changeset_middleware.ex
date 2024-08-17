defmodule GraphqlUserApiWeb.Middlewares.ChangesetMiddleware do
  @behaviour Absinthe.Middleware

  alias GraphqlUserApi.ErrorHandling.Handler

  @impl true
  def call(%{errors: changeset_errors} = resolution, _config) do
    case changeset_errors do
      [] ->
        resolution

      [_first | _rest] ->
        errors =
          Enum.map(changeset_errors, fn changeset ->
            Handler.extract_errors(changeset)
          end)

        Absinthe.Resolution.put_result(resolution, {:error, List.first(errors)})
    end
  end
end
