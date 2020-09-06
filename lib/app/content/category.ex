defmodule App.Content.Category do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "categories" do
    field :name, :string
    field :slug, :string
    field :is_published, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :slug, :is_published])
    |> validate_required([:name, :slug, :is_published])
    |> unique_constraint(:slug)
  end
end
