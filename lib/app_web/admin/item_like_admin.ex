defmodule App.Admin.ItemLikeAdmin do
  import Ecto.Query
  alias App.Accounts
  alias App.Content.Items

  def plural_name(_) do
    "User likes"
  end

  def custom_index_query(_conn, _schema, query) do
    from(r in query, preload: [:item, :user])
  end

  def index(_) do
    [
      id: nil,
      user_id: %{
        value: fn il -> "#{il.user.name} (#{il.user.email})" end,
        filters: Enum.map(Accounts.list_users(), fn u -> {u.name, u.id} end)
      },
      item_id: %{
        value: fn il -> "#{il.item.name} (#{il.item.slug})" end,
        filters: Enum.map(Items.list_items(), fn i -> {i.name, i.id} end)
      },
      inserted_at: nil
    ]
  end
end
