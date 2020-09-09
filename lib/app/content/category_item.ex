defmodule App.Content.CategoryItem do
  use Ecto.Schema
  import Ecto.Changeset
  alias App.Content.{Category, Item}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "category_items" do
    belongs_to :category, Category
    belongs_to :item, Item

    timestamps()
  end

  @doc false
  def changeset(category_item, attrs) do
    category_item
    |> cast(attrs, [:category_id, :item_id])
    |> validate_required([:category_id, :item_id])
  end
end
