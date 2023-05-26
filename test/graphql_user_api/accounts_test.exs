defmodule GraphqlUserApi.AccountsTest do
  use GraphqlUserApi.DataCase

  alias GraphqlUserApi.Accounts

  describe "users" do
    alias GraphqlUserApi.Accounts.User

    import GraphqlUserApi.AccountsFixtures

    @invalid_attrs %{email: nil, name: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{email: "some email", name: "some name"}

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.email == "some email"
      assert user.name == "some name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{email: "some updated email", name: "some updated name"}

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.email == "some updated email"
      assert user.name == "some updated name"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "preferences" do
    alias GraphqlUserApi.Accounts.Preference

    import GraphqlUserApi.AccountsFixtures

    @invalid_attrs %{likes_emails: nil, likes_faxes: nil, likes_phone_calls: nil}

    test "list_preferences/0 returns all preferences" do
      preference = preference_fixture()
      assert Accounts.list_preferences() == [preference]
    end

    test "get_preference!/1 returns the preference with given id" do
      preference = preference_fixture()
      assert Accounts.get_preference!(preference.id) == preference
    end

    test "create_preference/1 with valid data creates a preference" do
      valid_attrs = %{likes_emails: true, likes_faxes: true, likes_phone_calls: true}

      assert {:ok, %Preference{} = preference} = Accounts.create_preference(valid_attrs)
      assert preference.likes_emails == true
      assert preference.likes_faxes == true
      assert preference.likes_phone_calls == true
    end

    test "create_preference/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_preference(@invalid_attrs)
    end

    test "update_preference/2 with valid data updates the preference" do
      preference = preference_fixture()
      update_attrs = %{likes_emails: false, likes_faxes: false, likes_phone_calls: false}

      assert {:ok, %Preference{} = preference} = Accounts.update_preference(preference, update_attrs)
      assert preference.likes_emails == false
      assert preference.likes_faxes == false
      assert preference.likes_phone_calls == false
    end

    test "update_preference/2 with invalid data returns error changeset" do
      preference = preference_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_preference(preference, @invalid_attrs)
      assert preference == Accounts.get_preference!(preference.id)
    end

    test "delete_preference/1 deletes the preference" do
      preference = preference_fixture()
      assert {:ok, %Preference{}} = Accounts.delete_preference(preference)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_preference!(preference.id) end
    end

    test "change_preference/1 returns a preference changeset" do
      preference = preference_fixture()
      assert %Ecto.Changeset{} = Accounts.change_preference(preference)
    end
  end
end
