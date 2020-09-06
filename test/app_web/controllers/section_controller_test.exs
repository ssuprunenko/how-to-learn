defmodule AppWeb.SectionControllerTest do
  use AppWeb.ConnCase
  import App.Factory

  describe "show" do
    test "valid section", %{conn: conn} do
      insert(:section, %{name: "English", slug: "english"})

      response =
        conn
        |> get(Routes.section_path(conn, :show, "english"))
        |> html_response(200)

      assert response =~ "English"
    end

    test "invalid section", %{conn: conn} do
      conn = get(conn, Routes.section_path(conn, :show, "test"))

      assert %{slug: "english" = slug} = redirected_params(conn)
      assert redirected_to(conn) == Routes.section_path(conn, :show, slug)
    end
  end
end
