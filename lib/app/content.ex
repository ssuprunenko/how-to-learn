defmodule App.Content do
  @moduledoc """
  The Content context.
  """

  import Ecto.Query, warn: false
  alias App.Content.{Category, Section, Item}
  alias App.Repo

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  def list_categories do
    Repo.all(Category)
  end

  @doc """
  Gets a single category.

  Returns nil if the Category does not exist.

  ## Examples

      iex> get_category(123)
      %Category{}

      iex> get_category(456)
      ** (Ecto.NoResultsError)

  """
  def get_category(id), do: Repo.get(Category, id)

  def get_category_by_slug(nil), do: nil

  def get_category_by_slug(slug) do
    Repo.get_by(Category, slug: slug, is_published: true)
  end

  @doc """
  Returns the list of sections.

  ## Examples

      iex> list_sections()
      [%Section{}, ...]

  """
  def list_sections do
    Repo.all(Section)
  end

  @doc """
  Gets a single section.

  Return nil if the Section does not exist.

  ## Examples

      iex> get_section(123)
      %Section{}

      iex> get_section(456)
      nil

  """
  def get_section(id), do: Repo.get(Section, id)

  def get_section_by_slug(slug), do: Repo.get_by(Section, slug: slug)

  @doc """
  Returns the list of items.

  ## Examples

      iex> list_items()
      [%Item{}, ...]

  """
  def list_items do
    Repo.all(Item)
  end

  def list_items(section, nil, sort_by) do
    section.id
    |> Item.approved_by_section_query()
    |> Item.sort_by_query(sort_by, 20)
    |> Repo.all()
  end

  def list_items(section, category, sort_by) do
    section.id
    |> Item.approved_by_section_query()
    |> Item.with_category_query()
    |> Item.sort_by_query(sort_by, 20)
    |> Repo.all()
    |> Enum.filter(fn item -> item.category.slug == category.slug end)
  end

  @doc """
  Gets a single item.

  Returns nil if the Item does not exist.

  ## Examples

      iex> get_item(123)
      %Item{}

      iex> get_item(456)
      nil

  """
  def get_item(id), do: Repo.get(Item, id)
end
