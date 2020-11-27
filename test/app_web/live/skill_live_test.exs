defmodule AppWeb.SkillLiveTest do
  use AppWeb.ConnCase
  use AssertHTML
  import App.Factory
  import Phoenix.LiveViewTest
  alias AppWeb.SkillLive
  alias App.Content.Items

  describe "skill with no selected categories" do
    setup %{conn: conn} do
      skill = insert(:skill, %{name: "English", slug: "english"})

      [conn: conn, skill: skill]
    end

    test "valid skill", %{conn: conn, skill: skill} do
      {:ok, _view, html} = live(conn, Routes.live_path(conn, SkillLive, skill.slug))

      assert html =~ skill.name
    end

    test "invalid skill", %{conn: conn} do
      conn = get(conn, Routes.live_path(conn, SkillLive, "test"))

      assert redirected_to(conn, 302) == "/"
    end

    test "invalid category", %{conn: conn} do
      conn = get(conn, Routes.live_path(conn, SkillLive, "test", "test"))

      params = redirected_params(conn)

      refute Map.get(params, :category_slug)
      assert redirected_to(conn, 302) == "/"
    end
  end

  describe "categories" do
    setup %{conn: conn} do
      skill = insert(:skill, %{name: "English", slug: "english"})
      category = insert(:category)

      [conn: conn, skill: skill, category: category]
    end

    test "empty category", %{conn: conn, skill: skill, category: category} do
      {:ok, _view, html} =
        live(conn, Routes.live_path(conn, SkillLive, skill.slug, category.slug))

      assert_html html do
        assert_html("h1", text: "Best #{category.name} to Learn #{skill.name}")
        refute_html("h2")
      end
    end

    test "show category items", %{conn: conn, skill: skill, category: category} do
      category_two = insert(:category)

      Enum.each(insert_list(3, :item, skill: skill), fn item ->
        insert(:category_item, category: category, item: item)
      end)

      Enum.each(insert_list(2, :item, skill: skill), fn item ->
        insert(:category_item, category: category_two, item: item)
      end)

      {:ok, _view, html} =
        live(conn, Routes.live_path(conn, SkillLive, skill.slug, category.slug))

      assert_html html do
        assert_html("h1", text: "Best #{category.name} to Learn #{skill.name}")
        assert_html("h2", count: 3)
        assert html =~ "All (5)"
        assert html =~ "#{category.name} (3)"
        assert html =~ "#{category_two.name} (2)"
      end
    end
  end

  describe "like/unlike an item for unregistered users" do
    setup %{conn: conn} do
      skill = insert(:skill, %{name: "English", slug: "english"})
      category = insert(:category)
      item = insert(:item, skill: skill)
      insert(:category_item, category: category, item: item)

      [conn: conn, skill: skill, category: category, item: item]
    end

    test "show a flash message and change button text to unregistered users", %{
      conn: conn,
      skill: skill,
      category: category,
      item: item
    } do
      button_el = "#item-#{item.id} button"

      {:ok, view, _html} =
        live(conn, Routes.live_path(conn, SkillLive, skill.slug, category.slug))

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
      skill = insert(:skill, %{name: "English", slug: "english"})
      category = insert(:category)
      item = insert(:item, skill: skill)
      insert(:category_item, category: category, item: item)

      [conn: conn, skill: skill, category: category, item: item]
    end

    test "change item likes in db when user is logged in", %{
      conn: conn,
      skill: skill,
      category: category,
      item: item
    } do
      button_el = "#item-#{item.id} button"

      {:ok, view, _html} =
        live(conn, Routes.live_path(conn, SkillLive, skill.slug, category.slug))

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
