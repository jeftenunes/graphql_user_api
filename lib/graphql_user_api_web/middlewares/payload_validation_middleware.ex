defmodule GraphqlUserApiWeb.Middlewares.PayloadValidationMiddleware do
  @behaviour Absinthe.Middleware

  alias GraphqlUserApi.ErrorHandling.Handler

  @impl true
  def call(%{arguments: arguments} = resolution, _config) do
    # if are_all_integer_arguments_valid?(arguments) do
    #   resolution
    # else
    #   Absinthe.Resolution.put_result(
    #     resolution,
    #     {:error, Handler.handle_bad_request(arguments)}
    #   )
    # end
  end
end
