defmodule App.Content.SkillTest do
  use App.DataCase
  import App.Factory
  alias App.Content.Skill

  setup do
    skill = insert(:skill)

    [skill: skill]
  end

  describe "with_latest_items/2" do
    test "returns skill with latest items", %{skill: skill} do
      insert_list(4, :item, skill: skill, is_approved: true)
      item = insert(:item, skill: skill, is_approved: false)

      %{latest_items: items} = Skill.with_latest_items(skill, 5)
      assert length(items) == 4
      assert item not in items

      %{latest_items: items} = Skill.with_latest_items(skill, 2)
      assert length(items) == 2
    end

    test "items are empty when no items found", %{skill: skill} do
      %{latest_items: items} = Skill.with_latest_items(skill, 3)
      assert Enum.empty?(items)
    end
  end

  describe "with_top_items/3" do
    test "returns skill with top items by likes", %{skill: skill} do
      insert(:item, skill: skill, is_approved: true, likes: 10)
      insert(:item, skill: skill, is_approved: true, likes: 5)
      insert(:item, skill: skill, is_approved: true, likes: 50)
      insert(:item, skill: skill, is_approved: true, likes: 20)

      %{top_items: items} = Skill.with_top_items(skill, 3, :month)

      assert [%{likes: 50}, %{likes: 20}, %{likes: 10}] = items
    end

    test "returns top items only for latest month", %{skill: skill} do
      insert(:item,
        skill: skill,
        is_approved: true,
        likes: 10,
        inserted_at: Timex.shift(DateTime.utc_now(), months: -1)
      )

      insert(:item, skill: skill, is_approved: true, likes: 5)
      insert(:item, skill: skill, is_approved: true, likes: 50)

      %{top_items: items} = Skill.with_top_items(skill, 3, :month)
      assert [%{likes: 50}, %{likes: 5}] = items
    end
  end
end
