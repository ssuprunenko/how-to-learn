defmodule App.Content.Skill do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias App.Content.Item

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "skills" do
    field :name, :string
    field :slug, :string
    field :summary, :string

    field :items_count, :integer, virtual: true, default: 0

    has_many :latest_items, Item
    has_many :top_items, Item
    has_many :items, Item

    timestamps()
  end

  @doc false
  def changeset(skill, attrs) do
    skill
    |> cast(attrs, [:name, :slug, :summary])
    |> validate_required([:name, :slug])
    |> unique_constraint(:slug)
  end

  def with_latest_items(%__MODULE__{id: id} = skill, limit) do
    items =
      id
      |> Item.approved_by_skill_query()
      |> Item.latest(limit)

    Map.put(skill, :latest_items, items)
  end

  def with_items_count(%__MODULE__{id: id} = skill) do
    count =
      id
      |> Item.approved_by_skill_query()
      |> Item.count()

    Map.put(skill, :items_count, count)
  end

  def with_items_count(query) do
    from(s in query,
      left_join: i in assoc(s, :items),
      on: i.is_approved,
      group_by: s.id,
      select: %{id: s.id, slug: s.slug, name: s.name, items_count: count(i.id)}
    )
  end

  def with_top_items(%__MODULE__{id: id} = skill, limit, range \\ :month) do
    start_date = calculate_start_date(range)

    items =
      id
      |> Item.approved_by_skill_query()
      |> Item.sort_by_query(:top, limit)
      |> Item.created_since_date(start_date)

    Map.put(skill, :top_items, items)
  end

  defp calculate_start_date(:month) do
    DateTime.utc_now()
    |> Timex.beginning_of_month()
  end

  defp calculate_start_date(:year) do
    DateTime.utc_now()
    |> Timex.beginning_of_year()
  end
end
