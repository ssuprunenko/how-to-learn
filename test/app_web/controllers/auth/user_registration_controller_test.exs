defmodule AppWeb.Auth.UserRegistrationControllerTest do
  use AppWeb.ConnCase, async: true

  import App.AccountsFixtures
  import App.Factory

  describe "GET /auth/users/register" do
    test "renders registration page", %{conn: conn} do
      conn = get(conn, Routes.auth_user_registration_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "<h1>Register</h1>"
      assert response =~ "Log in</a>"
      assert response =~ "Register</a>"
    end

    test "redirects if already logged in", %{conn: conn} do
      conn =
        conn |> log_in_user(user_fixture()) |> get(Routes.auth_user_registration_path(conn, :new))

      assert redirected_to(conn) == "/"
    end
  end

  describe "POST /auth/users/register" do
    @tag :capture_log
    test "creates account and logs the user in", %{conn: conn} do
      insert(:skill, %{name: "English", slug: "english"})
      email = unique_user_email()

      conn =
        post(conn, Routes.auth_user_registration_path(conn, :create), %{
          "user" => %{"email" => email, "password" => valid_user_password()}
        })

      assert get_session(conn, :user_token)
      assert redirected_to(conn) =~ "/"

      # Now do a logged in request and assert on the menu
      conn = get(conn, "/english")
      response = html_response(conn, 200)
      assert response =~ email
      assert response =~ "Settings</a>"
      assert response =~ "Log out</a>"
    end

    test "render errors for invalid data", %{conn: conn} do
      conn =
        post(conn, Routes.auth_user_registration_path(conn, :create), %{
          "user" => %{"email" => "with spaces", "password" => "short"}
        })

      response = html_response(conn, 200)
      assert response =~ "<h1>Register</h1>"
      assert response =~ "must have the @ sign and no spaces"
      assert response =~ "should be at least 8 character"
    end
  end
end
