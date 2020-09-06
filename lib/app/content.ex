defmodule App.Content do
  @moduledoc """
  The Content context.
  """

  import Ecto.Query, warn: false
  alias App.Repo
  alias App.Content.Category

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

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category(id), do: Repo.get(Category, id)
end
