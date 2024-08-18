defmodule GraphqlUserApiWeb.Schema.Queries.UserTest do
  use GraphqlUserApi.DataCase

  alias GraphqlUserApi.{Accounts, AccountsFixtures}

  @users_by_preferences_doc """
    query UsersByPreferences($likesFaxes: Boolean, $likesEmails: Boolean, $likesPhoneCalls: Boolean) {
      users(likesFaxes: $likesFaxes, likesEmails: $likesEmails, likesPhoneCalls: $likesPhoneCalls) {
        id, name, email, preferences {
          likesFaxes,
          likesEmails,
          likesPhoneCalls
        }
      }
    }
  """

  @invalid_users_by_preferences_doc """
    query UsersByPreferences($likesFaxes: Boolean, $likesEmails: Boolean, $likesPhoneCalls: Boolean) {
      users(likesFaxes: $likesFaxes, likesEmails: $likesEmails, likesPhoneCalls: $likesPhoneCalls, invalid_param: $invalid_param) {
        id, name, email, preferences {
          likesFaxes,
          likesEmails,
          likesPhoneCalls
        }
      }
    }
  """

  @user_by_id_doc """
    query UserById($id: ID!) {
      user(id: $id) {
        id,
        name,
        email,
        preferences {
          likesFaxes,
          likesEmails,
          likesPhoneCalls
        }
      }
    }
  """

  describe "@users" do
    test "should find all users" do
      assert {:ok, %{data: data}} =
               Absinthe.run(@users_by_preferences_doc, GraphqlUserApiWeb.Schema, variables: %{})

      assert length(data["users"]) == 2
    end

    test "should find all users who like faxes" do
      assert {:ok, %{data: data}} =
               Absinthe.run(@users_by_preferences_doc, GraphqlUserApiWeb.Schema,
                 variables: %{
                   "likesFaxes" => true
                 }
               )

      assert length(data["users"]) == 1
      assert List.first(data["users"])["email"] == "user1@email.com"
    end

    test "should find all users who like emails but don't like phone calls" do
      assert {:ok, %{data: data}} =
               Absinthe.run(@users_by_preferences_doc, GraphqlUserApiWeb.Schema,
                 variables: %{
                   "likesEmails" => true,
                   "likesPhoneCalls" => false
                 }
               )

      assert length(data["users"]) == 0
    end

    test "should find all users who like emails and faxes but don't like phone calls" do
      assert {:ok, %{data: data}} =
               Absinthe.run(@users_by_preferences_doc, GraphqlUserApiWeb.Schema,
                 variables: %{
                   "likesFaxes" => true,
                   "likesEmails" => true,
                   "likesPhoneCalls" => false
                 }
               )

      assert length(data["users"]) == 0
    end

    test "should find all users who don't like emails nor phone calls" do
      assert {:ok, %{data: data}} =
               Absinthe.run(@users_by_preferences_doc, GraphqlUserApiWeb.Schema,
                 variables: %{
                   "likesEmails" => false,
                   "likesPhoneCalls" => false
                 }
               )

      assert length(data["users"]) == 2
    end

    test "retrieve all users should fail due to invalid parameters" do
      assert {:ok, %{errors: errors}} =
               Absinthe.run(@invalid_users_by_preferences_doc, GraphqlUserApiWeb.Schema,
                 variables: %{
                   "invalid_param" => "invalid_value"
                 }
               )

      assert List.first(errors)[:message] ==
               "Unknown argument \"invalid_param\" on field \"users\" of type \"RootQueryType\"."
    end

    test "should retrieve an user by id" do
      # arrange

      {:ok, test_usr} =
        Accounts.new_user(%{
          name: "Test User name 1",
          email: "testuser1@email.com",
          preferences: %{
            "likes_emails" => false,
            "likes_faxes" => true,
            "likes_phone_calls" => false
          }
        })

      # act

      assert {:ok, %{data: data}} =
               Absinthe.run(@user_by_id_doc, GraphqlUserApiWeb.Schema,
                 variables: %{
                   "id" => to_string(test_usr.id)
                 }
               )

      # assert

      assert to_string(test_usr.id) == data["user"]["id"]

      assert test_usr.name == data["user"]["name"]
      assert test_usr.email == data["user"]["email"]

      assert test_usr.preferences.likes_faxes ==
               data["user"]["preferences"]["likesFaxes"]

      assert test_usr.preferences.likes_emails ==
               data["user"]["preferences"]["likesEmails"]

      assert test_usr.preferences.likes_phone_calls ==
               data["user"]["preferences"]["likesPhoneCalls"]
    end

    test "should not retrieve an user by id - not found" do
      # act
      {:ok, users} =
        Accounts.all_users()

      inexistent_id =
        users
        |> Enum.map(fn u -> u.id end)
        |> AccountsFixtures.find_non_existent_user_id()

      assert {:ok, %{errors: errors}} =
               Absinthe.run(@user_by_id_doc, GraphqlUserApiWeb.Schema,
                 variables: %{
                   "id" => to_string(inexistent_id)
                 }
               )

      # assert

      assert %{
               code: :not_found,
               message: "not found",
               details: %{id: ^inexistent_id}
             } = List.first(errors)
    end
  end
end
