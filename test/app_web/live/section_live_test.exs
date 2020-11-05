defmodule AppWeb.SectionLiveTest do
  use AppWeb.ConnCase
  use AssertHTML
  import App.Factory
  import Phoenix.LiveViewTest
  alias AppWeb.SectionLive

  describe "section with no selected categories" do
    setup %{conn: conn} do
      section = insert(:section, %{name: "English", slug: "english"})

      [conn: conn, section: section]
    end

    test "valid section", %{conn: conn, section: section} do
      {:ok, _view, html} = live(conn, Routes.live_path(conn, SectionLive, section.slug))

      assert html =~ section.name
    end

    test "invalid section", %{conn: conn, section: section} do
      conn = get(conn, Routes.live_path(conn, SectionLive, "test"))

      assert redirected_params(conn).section_slug == section.slug
      assert redirected_to(conn) == Routes.live_path(conn, SectionLive, section.slug)
    end

    test "invalid category", %{conn: conn, section: section} do
      conn = get(conn, Routes.live_path(conn, SectionLive, "test", "test"))

      params = redirected_params(conn)

      assert params.section_slug == section.slug
      refute Map.get(params, :category_slug)
      assert redirected_to(conn) == Routes.live_path(conn, SectionLive, section.slug)
    end
  end

  describe "categories" do
    setup %{conn: conn} do
      section = insert(:section, %{name: "English", slug: "english"})
      category = insert(:category)

      [conn: conn, section: section, category: category]
    end

    test "empty category", %{conn: conn, section: section, category: category} do
      {:ok, _view, html} =
        live(conn, Routes.live_path(conn, SectionLive, section.slug, category.slug))

      assert_html html do
        assert_html("h1", text: "Best #{category.name} to learn #{section.name}")
        refute_html("h3")
      end
    end

    test "show category items", %{conn: conn, section: section, category: category} do
      category_two = insert(:category)

      Enum.each(insert_list(3, :item, section: section), fn item ->
        insert(:category_item, category: category, item: item)
      end)

      Enum.each(insert_list(2, :item, section: section), fn item ->
        insert(:category_item, category: category_two, item: item)
      end)

      {:ok, _view, html} =
        live(conn, Routes.live_path(conn, SectionLive, section.slug, category.slug))

      assert_html html do
        assert_html("h1", text: "Best #{category.name} to learn #{section.name}")
        assert_html("h3", count: 3)
        assert html =~ "All (5)"
        assert html =~ "#{category.name} (3)"
        assert html =~ "#{category_two.name} (2)"
      end
    end
  end
end
