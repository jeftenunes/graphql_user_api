defmodule GraphqlUserApiWeb.Schema.Subscriptions.PreferencesTest do
  use GraphqlUserApi.DataCase
  use GraphqlUserApiWeb.ConnCase
  use GraphqlUserApiWeb.SubscriptionCase

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

  @updated_preferences_doc """
    subscription UpdatedUserPreferences($userId: ID!){
      updatedUserPreferences(userId: $userId) {
        userId,
        likesEmails
        likesPhoneCalls
        likesFaxes
      }
    }
  """

  describe "@updatedUserPreferences" do
    test "should send an user when @updateUserPreferences mutation is triggered", %{
      socket: socket
    } do
      assert {:ok, usr} =
               Accounts.new_user(%{
                 :name => "name",
                 :email => "email",
                 :preferences => %{
                   "likes_faxes" => true,
                   "likes_emails" => false,
                   "likes_phone_calls" => true
                 }
               })

      ref =
        push_doc(socket, @updated_preferences_doc, variables: %{userId: usr.id})

      assert_reply ref, :ok, %{subscriptionId: subscription_id}

      payload = %{
        "userId" => usr.id,
        "likesFaxes" => false,
        "likesEmails" => true,
        "likesPhoneCalls" => false
      }

      response =
        build_conn()
        |> put_req_header("api_key", "api_key")
        |> post("/graphql", %{query: @update_preferences_doc, variables: payload})
        |> json_response(200)

      assert %{
               "data" => %{
                 "updateUserPreferences" => %{
                   "likesFaxes" => false,
                   "likesEmails" => true,
                   "likesPhoneCalls" => false
                 }
               }
             } = response

      assert_push "subscription:data", data

      user_id = to_string(usr.id)

      assert %{
               subscriptionId: ^subscription_id,
               result: %{
                 data: %{
                   "updatedUserPreferences" => %{
                     "userId" => ^user_id,
                     "likesFaxes" => false,
                     "likesEmails" => true,
                     "likesPhoneCalls" => false
                   }
                 }
               }
             } = data
    end
  end
end
