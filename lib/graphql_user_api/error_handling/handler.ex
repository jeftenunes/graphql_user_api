defmodule GraphqlUserApi.ErrorHandling.Handler do
  alias GraphqlUserApi.ErrorHandling.ErrorMessageUtils

  def extract_errors(%ErrorMessage{code: _code, message: _message, details: _details} = error) do
    error_message_map = ErrorMessage.to_jsonable_map(error)
    ErrorMessageUtils.not_found("not found", error_message_map.details.params)
  end

  def extract_errors(changeset) do
    Enum.map(changeset.errors, fn {field, error} ->
      build_error_message(changeset.changes, field, error)
    end)
  end

  defp build_error_message(
         changes,
         field,
         {message, [constraint: :unique, constraint_name: _constraint_name]}
       ) do
    ErrorMessageUtils.conflict("#{changes[field]} #{message}", %{
      field => changes[field]
    })
  end

  defp build_error_message(params, _, _) do
    ErrorMessageUtils.not_acceptable("Not acceptable payload", %{details: params})
  end
end
