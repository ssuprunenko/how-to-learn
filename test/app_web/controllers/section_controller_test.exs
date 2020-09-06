defmodule AppWeb.SectionControllerTest do
  use AppWeb.ConnCase

  describe "show" do
    test "valid section", %{conn: conn} do
      response =
        conn
        |> get(Routes.section_path(conn, :show, "english"))
        |> html_response(200)

      assert response =~ "English"
    end

    test "invalid section", %{conn: conn} do
      conn = get(conn, Routes.section_path(conn, :show, "test"))

      assert %{id: "english" = id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.section_path(conn, :show, id)
    end
  end
end
