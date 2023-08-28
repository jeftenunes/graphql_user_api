defmodule GraphqlUserApiWeb.Schema.Mutations.UserTest do
  use GraphqlUserApi.DataCase

  alias GraphqlUserApi.Accounts

  @create_user_doc """
    mutation CreateUser($email: String!, $name: String!, $preferences: PreferenceInput!) {
      createUser(email: $email, name: $name, preferences: $preferences) {
        id
        name
        email

        preferences {
          likesEmails
          likesPhoneCalls
          likesFaxes
        }
      }
    }
  """

  @update_user_doc """
    mutation UpdateUser($id: ID!, $email: String!, $name: String!) {
      updateUser(id: $id, email: $email, name: $name) {
        id
        name
        email

        preferences {
          likesEmails
          likesPhoneCalls
          likesFaxes
        }
      }
    }
  """

  describe "@createUser" do
    test "should create an user" do
      # act
      assert {:ok, %{data: data}} =
               Absinthe.run(@create_user_doc, GraphqlUserApiWeb.Schema,
                 variables: %{
                   "name" => "Name test",
                   "email" => "email@test.com",
                   "preferences" => %{
                     "likesFaxes" => true,
                     "likesEmails" => true
                   }
                 }
               )

      # assert
      assert data["createUser"]["name"] == "Name test"
      assert data["createUser"]["email"] == "email@test.com"
      assert data["createUser"]["preferences"]["likesFaxes"] == true
      assert data["createUser"]["preferences"]["likesEmails"] == true
    end

    test "should not create an user - email missing" do
      # act
      assert {:ok, %{errors: errors}} =
               Absinthe.run(@create_user_doc, GraphqlUserApiWeb.Schema,
                 variables: %{
                   "name" => "Name test",
                   "preferences" => %{
                     "likesFaxes" => true,
                     "likesEmails" => true
                   }
                 }
               )

      # assert
      assert List.first(errors)[:message] == "Variable \"email\": Expected non-null, found null."
    end

    test "should not create an user - user name missing" do
      assert {:ok, %{errors: errors}} =
               Absinthe.run(@create_user_doc, GraphqlUserApiWeb.Schema,
                 variables: %{
                   "email" => "email@test.com",
                   "preferences" => %{
                     "likesFaxes" => true,
                     "likesEmails" => true
                   }
                 }
               )

      assert List.first(errors)[:message] == "Variable \"name\": Expected non-null, found null."
    end

    test "should not create an user - preferences missing" do
      assert {:ok, %{errors: errors}} =
               Absinthe.run(@create_user_doc, GraphqlUserApiWeb.Schema,
                 variables: %{
                   "name" => "Name test",
                   "email" => "email@test.com"
                 }
               )

      assert List.first(errors)[:message] ==
               "Variable \"preferences\": Expected non-null, found null."
    end
  end

  describe "@udateUser" do
    test "should update an user" do
      # arrange
      assert {:ok, created_user} =
               Accounts.new_user(%{
                 :name => "name",
                 :email => "email",
                 :preferences => %{
                   "likes_faxes" => true,
                   "likes_emails" => false,
                   "likes_phone_calls" => true
                 }
               })

      # act
      assert {:ok, %{data: data}} =
               Absinthe.run(@update_user_doc, GraphqlUserApiWeb.Schema,
                 variables: %{
                   "id" => to_string(created_user.id),
                   "name" => "updated name",
                   "email" => "updated email"
                 }
               )

      # assert
      assert data["updateUser"]["name"] == "updated name"
      assert data["updateUser"]["email"] == "updated email"
    end

    test "should not update user - user not found" do
      # act
      assert {:ok, %{errors: errors}} =
               Absinthe.run(@update_user_doc, GraphqlUserApiWeb.Schema,
                 variables: %{
                   "id" => "0",
                   "name" => "updated name",
                   "email" => "updated email"
                 }
               )

      assert List.first(errors).message == "user not found"
    end

    test "should not update user - missing parameter: id" do
      # act
      assert {:ok, %{errors: errors}} =
               Absinthe.run(@update_user_doc, GraphqlUserApiWeb.Schema,
                 variables: %{
                   "name" => "updated name",
                   "email" => "updated email"
                 }
               )

      # assert
      assert List.first(errors).message == "Variable \"id\": Expected non-null, found null."
    end

    test "should not update user - missing parameter: name" do
      # act
      assert {:ok, %{errors: errors}} =
               Absinthe.run(@update_user_doc, GraphqlUserApiWeb.Schema,
                 variables: %{
                   "id" => "1",
                   "email" => "updated email"
                 }
               )

      # assert
      assert List.first(errors).message == "Variable \"name\": Expected non-null, found null."
    end

    test "should not update user - missing parameter: email" do
      # act
      assert {:ok, %{errors: errors}} =
               Absinthe.run(@update_user_doc, GraphqlUserApiWeb.Schema,
                 variables: %{
                   "id" => "1",
                   "name" => "updated name"
                 }
               )

      # assert
      assert List.first(errors).message == "Variable \"email\": Expected non-null, found null."
    end
  end
end
