defmodule App.Content.Item do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias App.Content.{Category, CategoryItem, Section}
  alias App.Repo

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

    field :category, :map, virtual: true

    belongs_to :section, Section

    many_to_many :categories,
                 Category,
                 join_through: CategoryItem,
                 on_replace: :delete

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

  def approved_by_section_query(section_id) do
    from(i in __MODULE__,
      where: i.section_id == ^section_id and i.is_approved
    )
  end

  def top_by_likes_query(section_id, limit) do
    query = approved_by_section_query(section_id)
    from(i in subquery(query), order_by: [desc: i.likes], limit: ^limit)
  end

  def latest(query, limit) do
    from(i in subquery(query),
      order_by: [desc: i.inserted_at],
      limit: ^limit,
      select: %{
        name: i.name,
        slug: i.slug,
        summary: i.summary,
        description: i.description,
        likes: i.likes
      }
    )
    |> Repo.all()
  end

  def created_since_date(query, date) do
    from(i in subquery(query),
      where: i.inserted_at >= ^date,
      select: %{
        name: i.name,
        slug: i.slug,
        summary: i.summary,
        description: i.description,
        likes: i.likes
      }
    )
    |> Repo.all()
  end

  def with_category_query(section_id) do
    query = approved_by_section_query(section_id)

    from(i in subquery(query),
      inner_join: ci in CategoryItem,
      on: ci.item_id == i.id,
      inner_join: c in assoc(ci, :category),
      where: c.is_published,
      select: %{
        name: i.name,
        slug: i.slug,
        likes: i.likes,
        category: %{name: c.name, slug: c.slug}
      },
      order_by: [desc: i.likes]
    )
  end
end
