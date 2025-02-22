defmodule App.Content.Category do
  use Ecto.Schema
  import Ecto.Changeset
  alias App.Content.{CategoryItem, Item}
  alias App.Repo

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "categories" do
    field :name, :string
    field :slug, :string
    field :is_published, :boolean, default: false

    many_to_many :items,
                 Item,
                 join_through: CategoryItem,
                 on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :slug, :is_published])
    |> validate_required([:name, :slug, :is_published])
    |> unique_constraint(:slug)
  end

  def with_top_items(skill_id, limit) do
    skill_id
    |> Item.approved_by_skill_query()
    |> Item.with_category_query()
    |> Item.with_preloaded_skill()
    |> Repo.all()
    |> Enum.group_by(& &1.category)
    |> Enum.map(fn {category, items} ->
      items_count = Enum.count(items)
      top_items = Enum.take(items, limit)
      Map.merge(category, %{items: top_items, items_count: items_count})
    end)
    |> Enum.sort_by(& &1.name)
  end
end
