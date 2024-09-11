defmodule GraphqlUserApi.ErrorHandling.ErrorMessageUtilsTest do
  use GraphqlUserApi.DataCase

  alias GraphqlUserApi.ErrorHandling.ErrorMessageUtils

  describe "@ErrorMessageUtils" do
    test "should return not found error" do
      # act
      assert %{message: "message", code: :not_found, details: %{id: 10000}} =
               ErrorMessageUtils.not_found("message", %{id: 10000})
    end

    test "should return internal_server_error_found error" do
      # act
      assert %{message: "message", code: :internal_server_error, details: %{key: "value"}} =
               ErrorMessageUtils.internal_server_error_found("message", %{key: "value"})
    end

    test "should return not acceptable error" do
      # act
      assert %{message: "message", code: :bad_request, details: %{key: "value"}} =
               ErrorMessageUtils.not_acceptable("message", %{key: "value"})
    end

    test "should return conflict error" do
      # act
      assert %{message: "message", code: :conflict, details: %{user_id: 10000}} =
               ErrorMessageUtils.conflict("message", %{user_id: 10000})
    end
  end
end
