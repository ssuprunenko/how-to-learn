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

  describe "skills" do
    test "list_skills/0 returns all skills" do
      skill = insert(:skill)
      assert Content.list_skills() == [skill]
    end

    test "get_skill/1 returns the skill with given id" do
      skill = insert(:skill)
      assert Content.get_skill(skill.id) == skill
    end

    test "get_skill_by_slug/1 returns the skill with given id" do
      skill = insert(:skill)
      assert Content.get_skill_by_slug(skill.slug) == skill
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
