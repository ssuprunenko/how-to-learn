defmodule App.ContentTest do
  use App.DataCase
  import App.Factory

  alias App.Content
  alias App.Content.Items

  describe "categories" do
    test "list_categories/0 returns all categories" do
      category = insert(:category)
      assert Content.list_categories() == [category]
    end

    test "get_category/1 returns the category with given id" do
      category = insert(:category)
      assert Content.get_category(category.id) == category
    end
  end

  describe "sections" do
    test "list_sections/0 returns all sections" do
      section = insert(:section)
      assert Content.list_sections() == [section]
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

  describe "items" do
    test "list_items/0 returns all items" do
      insert(:item)
      assert length(Items.list_items()) == 1
    end

    test "get_item/1 returns the item with given id" do
      item = insert(:item)
      assert Items.get_item(item.id).id == item.id
    end
  end
end
