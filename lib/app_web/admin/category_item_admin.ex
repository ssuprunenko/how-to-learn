defmodule App.Admin.CategoryItemAdmin do
  alias App.Content

  def plural_name(_) do
    "Categories-Items"
  end

  def index(_) do
    [
      id: nil,
      category_id: %{
        value: fn ci -> Content.get_category(ci.category_id).name end,
        filters: Enum.map(Content.list_categories(), fn c -> {c.name, c.id} end)
      },
      item_id: %{
        value: fn ci -> Content.get_item(ci.item_id).name end,
        filters: Enum.map(Content.list_items(), fn i -> {i.name, i.id} end)
      },
      inserted_at: nil
    ]
  end
end
