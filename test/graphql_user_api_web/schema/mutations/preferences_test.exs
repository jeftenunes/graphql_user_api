defmodule GraphqlUserApiWeb.Schema.Mutations.PreferencesTest do
  use GraphqlUserApi.DataCase

  alias GraphqlUserApi.Accounts

  @update_preferences_doc """
    mutation UpdateUserPreferences($userId: ID!, $likesFaxes: Boolean, $likesEmails: Boolean, $likesPhoneCalls: Boolean!) {
      updateUserPreferences(userId: $userId, likesFaxes: $likesFaxes, likesEmails: $likesEmails, likesPhoneCalls: $likesPhoneCalls) {
          likesEmails
          likesPhoneCalls
          likesFaxes
      }
    }
  """

  describe "@updateUserPreferences" do
    test "should update an user preferences" do
      # arrange
      assert {:ok, created_user} =
               Accounts.new_user(%{
                 name: "name",
                 email: "email",
                 preferences: %{
                   "likes_faxes" => true,
                   "likes_emails" => false,
                   "likes_phone_calls" => true
                 }
               })

      # act
      assert {:ok, %{data: data}} =
               Absinthe.run(@update_preferences_doc, GraphqlUserApiWeb.Schema,
                 variables: %{
                   "userId" => to_string(created_user.id),
                   "likesFaxes" => false,
                   "likesPhoneCalls" => false
                 },
                 context: %{api_key: "api_key"}
               )

      # assert
      assert data["updateUserPreferences"]["likesFaxes"] == false
      assert data["updateUserPreferences"]["likesEmails"] == false
      assert data["updateUserPreferences"]["likesPhoneCalls"] == false
    end

    test "should not update an user preferences - missing parameter: likesPhoneCalls" do
      # arrange
      assert {:ok, created_user} =
               Accounts.new_user(%{
                 name: "name",
                 email: "email",
                 preferences: %{
                   "likes_faxes" => true,
                   "likes_emails" => false,
                   "likes_phone_calls" => true
                 }
               })

      # act
      assert {:ok, %{errors: errors}} =
               Absinthe.run(@update_preferences_doc, GraphqlUserApiWeb.Schema,
                 variables: %{
                   "userId" => to_string(created_user.id),
                   "likesFaxes" => false,
                   "likesEmails" => true
                 }
               )

      # assert
      assert List.first(errors).message ==
               "In argument \"likesPhoneCalls\": Expected type \"Boolean!\", found null."
    end

    test "should not update an user preferences - missing parameter: userId" do
      # arrange
      assert {:ok, _created_user} =
               Accounts.new_user(%{
                 name: "name",
                 email: "email",
                 preferences: %{
                   "likes_faxes" => true,
                   "likes_emails" => false,
                   "likes_phone_calls" => true
                 }
               })

      # act
      assert {:ok, %{errors: errors}} =
               Absinthe.run(@update_preferences_doc, GraphqlUserApiWeb.Schema,
                 variables: %{
                   "likesFaxes" => false,
                   "likesEmails" => true,
                   "likesPhoneCalls" => true
                 }
               )

      # assert
      assert List.first(errors).message ==
               "In argument \"userId\": Expected type \"ID!\", found null."
    end

    test "should not update an user preferences - user not found" do
      # act
      assert {:ok, %{errors: errors}} =
               Absinthe.run(@update_preferences_doc, GraphqlUserApiWeb.Schema,
                 variables: %{
                   "userId" => "0",
                   "likesFaxes" => false,
                   "likesEmails" => true,
                   "likesPhoneCalls" => true
                 },
                 context: %{api_key: "api_key"}
               )

      # assert
      assert List.first(errors).message == "not found"
    end
  end
end
