defmodule App.Content do
  @moduledoc """
  The Content context.
  """

  import Ecto.Query, warn: false
  alias App.Content.{Category, Skill}
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
  Returns the list of skills.

  ## Examples

      iex> list_skills()
      [%Skill{}, ...]

  """
  def list_skills do
    Repo.all(Skill)
  end

  def skills_for_homepage do
    Skill
    |> Skill.with_items_count()
    |> Repo.all()
  end

  @doc """
  Gets a single skill.

  Return nil if the Skill does not exist.

  ## Examples

      iex> get_skill(123)
      %Skill{}

      iex> get_skill(456)
      nil

  """
  def get_skill(id), do: Repo.get(Skill, id)

  def get_skill_by_slug("all"), do: %Skill{slug: "all"}
  def get_skill_by_slug(slug), do: Repo.get_by(Skill, slug: slug)
end
