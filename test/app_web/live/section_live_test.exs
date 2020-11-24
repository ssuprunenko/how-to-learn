defmodule AppWeb.SectionLiveTest do
  use AppWeb.ConnCase
  use AssertHTML
  import App.Factory
  import Phoenix.LiveViewTest
  alias AppWeb.SectionLive
  alias App.Content.Items

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
        refute_html("h2")
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
        assert_html("h2", count: 3)
        assert html =~ "All (5)"
        assert html =~ "#{category.name} (3)"
        assert html =~ "#{category_two.name} (2)"
      end
    end
  end

  describe "like/unlike an item for unregistered users" do
    setup %{conn: conn} do
      section = insert(:section, %{name: "English", slug: "english"})
      category = insert(:category)
      item = insert(:item, section: section)
      insert(:category_item, category: category, item: item)

      [conn: conn, section: section, category: category, item: item]
    end

    test "show a flash message and change button text to unregistered users", %{
      conn: conn,
      section: section,
      category: category,
      item: item
    } do
      button_el = "#item-#{item.id} button"

      {:ok, view, _html} =
        live(conn, Routes.live_path(conn, SectionLive, section.slug, category.slug))

      assert has_element?(view, button_el, to_string(item.likes))
      assert has_element?(view, ".alert-info", "")

      # Like
      view
      |> element(button_el)
      |> render_click()

      assert has_element?(view, button_el, to_string(item.likes + 1))
      assert has_element?(view, ".alert-info", "Log in or register to save your likes")
      assert Items.get_item(item.id).likes == item.likes

      # Unike
      view
      |> element(button_el)
      |> render_click()

      assert has_element?(view, button_el, to_string(item.likes))
      assert Items.get_item(item.id).likes == item.likes
    end
  end

  describe "like/unlike an items for logged-in users" do
    setup :register_and_log_in_user
    setup %{conn: conn} do
      section = insert(:section, %{name: "English", slug: "english"})
      category = insert(:category)
      item = insert(:item, section: section)
      insert(:category_item, category: category, item: item)

      [conn: conn, section: section, category: category, item: item]
    end

    test "change item likes in db when user is logged in", %{
      conn: conn,
      section: section,
      category: category,
      item: item
    } do
      button_el = "#item-#{item.id} button"

      {:ok, view, _html} =
        live(conn, Routes.live_path(conn, SectionLive, section.slug, category.slug))

      # Like
      view
      |> element(button_el)
      |> render_click()

      assert has_element?(view, button_el, to_string(item.likes + 1))
      refute has_element?(view, ".alert-info", "Log in or register to save your likes")
      assert Items.get_item(item.id).likes == item.likes + 1

      # Unike
      view
      |> element(button_el)
      |> render_click()

      assert has_element?(view, button_el, to_string(item.likes))
      assert Items.get_item(item.id).likes == item.likes
    end
  end
end
