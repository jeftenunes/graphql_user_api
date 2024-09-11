defmodule GraphqlUserApiWeb.Schema.Subscriptions.UsersTest do
  use GraphqlUserApi.DataCase
  use GraphqlUserApiWeb.ConnCase
  use GraphqlUserApiWeb.SubscriptionCase

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

  @created_user_doc """
    subscription CreatedUser{
      createdUser {
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

  describe "@createdUser" do
    test "should send an user when @createUser mutation is triggered", %{
      socket: socket
    } do
      ref = push_doc(socket, @created_user_doc, variables: %{})

      payload = %{
        "name" => "Name test",
        "email" => "email@test.com",
        "preferences" => %{
          "likesFaxes" => true,
          "likesEmails" => true
        }
      }

      assert_reply ref, :ok, %{subscriptionId: subscription_id}

      response =
        build_conn()
        |> put_req_header("api_key", "api_key")
        |> post("/graphql", %{query: @create_user_doc, variables: payload})
        |> json_response(200)

      assert %{
               "data" => %{
                 "createUser" => %{
                   "name" => "Name test",
                   "email" => "email@test.com",
                   "preferences" => %{
                     "likesFaxes" => true,
                     "likesEmails" => true
                   }
                 }
               }
             } = response

      assert_push "subscription:data", data

      assert %{
               subscriptionId: ^subscription_id,
               result: %{
                 data: %{
                   "createdUser" => %{
                     "id" => _id,
                     "name" => "Name test",
                     "email" => "email@test.com",
                     "preferences" => %{
                       "likesFaxes" => true,
                       "likesEmails" => true
                     }
                   }
                 }
               }
             } = data
    end
  end
end
