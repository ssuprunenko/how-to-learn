defmodule App.ContentTest do
  use App.DataCase
  import App.Factory

  alias App.Content

  describe "categories" do
    test "list_categories/0 returns all categories" do
      insert(:category)
      assert length(Content.list_categories()) == 1
    end

    test "get_category/1 returns the category with given id" do
      category = insert(:category)
      assert Content.get_category(category.id) == category
    end
  end

  describe "sections" do
    test "list_sections/0 returns all sections" do
      insert(:section)
      assert length(Content.list_sections()) == 1
    end

    test "get_section/1 returns the section with given id" do
      section = insert(:section)
      assert Content.get_section(section.id) == section
    end

    test "get_section_by_slug/1 returns the section with given id" do
      section = insert(:section)
      assert Content.get_section_by_slug(section.slug) == section
    end
  end
end
