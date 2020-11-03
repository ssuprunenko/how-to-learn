defmodule AppWeb.CategoryControllerTest do
  use AppWeb.ConnCase, async: true
  use AssertHTML
  import App.Factory

  describe "show" do
    test "empty category", %{conn: conn} do
      section = insert(:section)
      category = insert(:category)

      response =
        conn
        |> get(Routes.section_category_path(conn, :show, section.slug, category.slug))
        |> html_response(200)

      assert response =~ section.name
      assert response =~ category.name
      refute_html(response, "h2")
    end

    test "show category items", %{conn: conn} do
      section = insert(:section)
      category = insert(:category)
      category_two = insert(:category)

      Enum.each(insert_list(3, :item, section: section), fn item ->
        insert(:category_item, category: category, item: item)
      end)

      Enum.each(insert_list(2, :item, section: section), fn item ->
        insert(:category_item, category: category_two, item: item)
      end)

      response =
        conn
        |> get(Routes.section_category_path(conn, :show, section.slug, category.slug))
        |> html_response(200)

      assert response =~ section.name
      assert response =~ category.name
      assert_html(response, "h2", count: 3)
    end
  end
end
