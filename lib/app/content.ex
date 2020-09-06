defmodule App.Content do
  @moduledoc """
  The Content context.
  """

  import Ecto.Query, warn: false
  alias App.Repo
  alias App.Content.{Category, Section}

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
end
