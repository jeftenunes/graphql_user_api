defmodule GraphqlUserApiWeb.Schema.Subscriptions.PreferencesTest do
  use GraphqlUserApi.DataCase
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

      ref =
        push_doc(socket, @update_preferences_doc,
          variables: %{
            "userId" => usr.id,
            "likesFaxes" => false,
            "likesEmails" => true,
            "likesPhoneCalls" => false
          }
        )

      assert_reply ref, :ok, reply

      assert %{
               data: %{
                 "updateUserPreferences" => %{
                   "likesFaxes" => false,
                   "likesEmails" => true,
                   "likesPhoneCalls" => false
                 }
               }
             } = reply

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
