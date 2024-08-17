defmodule GraphqlUserApi.ErrorHandling.ErrorMessageBuilder do
  def not_found(message, %{id: _id} = details) do
    build_error(:not_found, message, details)
  end

  def internal_server_error_found(message, details) do
    build_error(:internal_server_error, message, details)
  end

  def not_acceptable(message, details) do
    build_error(:bad_request, message, details)
  end

  def conflict(message, details) do
    build_error(:conflict, message, details)
  end

  defp build_error(code, message, details),
    do: %{code: code, message: message, details: details}
end
