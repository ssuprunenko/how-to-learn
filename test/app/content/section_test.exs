defmodule App.Content.SectionTest do
  use App.DataCase
  import App.Factory
  alias App.Content.Section

  setup do
    section = insert(:section)

    [section: section]
  end

  describe "with_latest_items/2" do
    test "returns section with latest items", %{section: section} do
      insert_list(4, :item, section: section, is_approved: true)
      item = insert(:item, section: section, is_approved: false)

      %{latest_items: items} = Section.with_latest_items(section, 5)
      assert length(items) == 4
      assert item not in items

      %{latest_items: items} = Section.with_latest_items(section, 2)
      assert length(items) == 2
    end

    test "items are empty when no items found", %{section: section} do
      %{latest_items: items} = Section.with_latest_items(section, 3)
      assert Enum.empty?(items)
    end
  end

  describe "with_top_items/3" do
    test "returns section with top items by likes", %{section: section} do
      insert(:item, section: section, is_approved: true, likes: 10)
      insert(:item, section: section, is_approved: true, likes: 5)
      insert(:item, section: section, is_approved: true, likes: 50)
      insert(:item, section: section, is_approved: true, likes: 20)

      %{top_items: items} = Section.with_top_items(section, 3, :month)

      assert [%{likes: 50}, %{likes: 20}, %{likes: 10}] = items
    end

    test "returns top items only for latest month", %{section: section} do
      insert(:item,
        section: section,
        is_approved: true,
        likes: 10,
        inserted_at: Timex.shift(DateTime.utc_now(), months: -1)
      )

      insert(:item, section: section, is_approved: true, likes: 5)
      insert(:item, section: section, is_approved: true, likes: 50)

      %{top_items: items} = Section.with_top_items(section, 3, :month)
      assert [%{likes: 50}, %{likes: 5}] = items
    end
  end
end
