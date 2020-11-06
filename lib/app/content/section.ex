defmodule App.Content.Section do
  use Ecto.Schema
  import Ecto.Changeset
  alias App.Content.Item

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "sections" do
    field :name, :string
    field :slug, :string
    field :summary, :string

    field :items_count, :integer, virtual: true, default: 0

    has_many :latest_items, Item
    has_many :top_items, Item

    timestamps()
  end

  @doc false
  def changeset(section, attrs) do
    section
    |> cast(attrs, [:name, :slug, :summary])
    |> validate_required([:name, :slug])
    |> unique_constraint(:slug)
  end

  def with_latest_items(%__MODULE__{id: id} = section, limit) do
    items =
      id
      |> Item.approved_by_section_query()
      |> Item.latest(limit)

    Map.put(section, :latest_items, items)
  end

  def with_items_count(%__MODULE__{id: id} = section) do
    count =
      id
      |> Item.approved_by_section_query()
      |> Item.count()

    Map.put(section, :items_count, count)
  end

  def with_top_items(%__MODULE__{id: id} = section, limit, range \\ :month) do
    start_date = calculate_start_date(range)

    items =
      id
      |> Item.approved_by_section_query()
      |> Item.sort_by_query(:top, limit)
      |> Item.created_since_date(start_date)

    Map.put(section, :top_items, items)
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
