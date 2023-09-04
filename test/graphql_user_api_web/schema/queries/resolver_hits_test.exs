defmodule GraphqlUserApiWeb.Schema.Queries.ResolverHitsTest do
  use GraphqlUserApi.DataCase

  @resolver_hits_query_doc """
    query ResolverHits($key: String!) {
      resolverHits(key: $key) {
        hitsCount
      }
    }
  """

  @all_users_query_doc """
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

  @update_preferences_doc """
    mutation UpdateUserPreferences($userId: ID!, $likesFaxes: Boolean, $likesEmails: Boolean, $likesPhoneCalls: Boolean!) {
      updateUserPreferences(userId: $userId, likesFaxes: $likesFaxes, likesEmails: $likesEmails, likesPhoneCalls: $likesPhoneCalls) {
          likesEmails
          likesPhoneCalls
          likesFaxes
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

  describe "@resolverHits" do
    test "should retrieve hit count for create_user resolver" do
      # arrange
      assert {:ok, %{data: initial_data}} =
               Absinthe.run(@resolver_hits_query_doc, GraphqlUserApiWeb.Schema,
                 variables: %{
                   "key" => "create_user"
                 }
               )

      initial_hits_count = initial_data["resolverHits"]["hitsCount"]

      assert {:ok, %{data: _}} =
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

      assert {:ok, %{data: data}} =
               Absinthe.run(@resolver_hits_query_doc, GraphqlUserApiWeb.Schema,
                 variables: %{
                   "key" => "create_user"
                 }
               )

      assert data["resolverHits"]["hitsCount"] == initial_hits_count + 1
    end

    test "should retrieve hit count for update_user resolver" do
      # arrange
      assert {:ok, %{data: initial_data}} =
               Absinthe.run(@resolver_hits_query_doc, GraphqlUserApiWeb.Schema,
                 variables: %{
                   "key" => "update_user"
                 }
               )

      initial_hits_count = initial_data["resolverHits"]["hitsCount"]

      assert {:ok, %{data: created_usr}} =
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

      assert {:ok, %{data: _}} =
               Absinthe.run(@update_user_doc, GraphqlUserApiWeb.Schema,
                 variables: %{
                   "id" => to_string(created_usr["createUser"]["id"]),
                   "name" => "updated name",
                   "email" => "updated email"
                 }
               )

      assert {:ok, %{data: data}} =
               Absinthe.run(@resolver_hits_query_doc, GraphqlUserApiWeb.Schema,
                 variables: %{
                   "key" => "update_user"
                 }
               )

      assert data["resolverHits"]["hitsCount"] == initial_hits_count + 1
    end

    test "should retrieve hit count for get_all resolver" do
      # arrange
      assert {:ok, %{data: initial_data}} =
               Absinthe.run(@resolver_hits_query_doc, GraphqlUserApiWeb.Schema,
                 variables: %{
                   "key" => "get_all"
                 }
               )

      initial_hits_count = initial_data["resolverHits"]["hitsCount"]

      assert {:ok, %{data: _}} =
               Absinthe.run(@all_users_query_doc, GraphqlUserApiWeb.Schema, variables: %{})

      assert {:ok, %{data: data}} =
               Absinthe.run(@resolver_hits_query_doc, GraphqlUserApiWeb.Schema,
                 variables: %{
                   "key" => "get_all"
                 }
               )

      assert data["resolverHits"]["hitsCount"] == initial_hits_count + 1
    end

    test "should retrieve hit count for get_user_by resolver" do
      # arrange
      assert {:ok, %{data: initial_data}} =
               Absinthe.run(@resolver_hits_query_doc, GraphqlUserApiWeb.Schema,
                 variables: %{
                   "key" => "get_user_by"
                 }
               )

      initial_hits_count = initial_data["resolverHits"]["hitsCount"]

      assert {:ok, %{data: created_usr}} =
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

      assert {:ok, %{data: _}} =
               Absinthe.run(@user_by_id_doc, GraphqlUserApiWeb.Schema,
                 variables: %{
                   "id" => to_string(created_usr["createUser"]["id"])
                 }
               )

      assert {:ok, %{data: data}} =
               Absinthe.run(@resolver_hits_query_doc, GraphqlUserApiWeb.Schema,
                 variables: %{
                   "key" => "get_user_by"
                 }
               )

      assert data["resolverHits"]["hitsCount"] == initial_hits_count + 1
    end

    test "should retrieve hit count for update preference resolver" do
      # arrange
      assert {:ok, %{data: initial_data}} =
               Absinthe.run(@resolver_hits_query_doc, GraphqlUserApiWeb.Schema,
                 variables: %{
                   "key" => "update"
                 }
               )

      initial_hits_count = initial_data["resolverHits"]["hitsCount"]

      assert {:ok, %{data: created_usr}} =
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

      assert {:ok, %{data: data}} =
               Absinthe.run(@update_preferences_doc, GraphqlUserApiWeb.Schema,
                 variables: %{
                   "userId" => to_string(created_usr["createUser"]["id"]),
                   "likesFaxes" => false,
                   "likesPhoneCalls" => false
                 }
               )

      assert {:ok, %{data: data}} =
               Absinthe.run(@resolver_hits_query_doc, GraphqlUserApiWeb.Schema,
                 variables: %{
                   "key" => "update"
                 }
               )

      assert data["resolverHits"]["hitsCount"] == initial_hits_count + 1
    end
  end
end
