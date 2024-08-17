defmodule GraphqlUserApi.ErrorHandling.Handler do
  alias GraphqlUserApi.ErrorHandling.ErrorMessageBuilder

  def extract_errors(%ErrorMessage{code: code, message: message, details: details} = error) do
    ErrorMessage.to_jsonable_map(error)
  end

  def extract_errors(%{code: code} = error)
      when code in [:conflict, :bad_request] do
    error
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
    ErrorMessageBuilder.conflict("#{changes[field]} #{message}", %{
      field => changes[field]
    })
  end

  defp build_error_message(params, _, _) do
    ErrorMessageBuilder.not_acceptable("Not acceptable payload", %{details: params})
  end
end
