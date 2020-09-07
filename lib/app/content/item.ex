defmodule App.Content.Item do
  use Ecto.Schema
  import Ecto.Changeset
  alias App.Content.Section

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "items" do
    field :name, :string
    field :slug, :string
    field :url, :string

    field :author, :string
    field :author_url, :string

    field :summary, :string
    field :description, :string

    field :license, LicenseEnum, default: :free
    field :has_trial, :boolean, default: false

    field :likes, :integer, default: 0
    field :is_approved, :boolean, default: false

    belongs_to :section, Section

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [
      :name,
      :slug,
      :url,
      :summary,
      :description,
      :author,
      :author_url,
      :license,
      :has_trial,
      :likes,
      :section_id,
      :is_approved
    ])
    |> validate_required([:name, :slug, :url, :section_id])
    |> unique_constraint(:slug)
  end
end
