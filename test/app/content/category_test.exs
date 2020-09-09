defmodule App.Content.CategoryTest do
  use App.DataCase
  import App.Factory
  alias App.Content.Category

  setup do
    section = insert(:section)

    [section: section]
  end

  describe "with_top_items/2" do
    test "returns all categories by section with top N items", %{section: section} do
      3
      |> insert_list(:category)
      |> Enum.each(fn category ->
        4
        |> insert_list(:item, section: section, is_approved: true)
        |> Enum.each(fn item ->
          insert(:category_item, category: category, item: item)
        end)
      end)

      categories = Category.with_top_items(section.id, 3)

      assert length(categories) == 3
      assert Enum.all?(categories, fn cat -> length(cat.items) == 3 end)
    end
  end
end
