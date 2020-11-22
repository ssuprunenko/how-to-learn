defmodule App.Content.Items do
  alias App.Content.{Item, ItemLike}
  alias App.Repo
  import Ecto.Query

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

  def mark_installed(items, user_id) when is_list(items) and is_binary(user_id) do
    liked_ids =
      ItemLike
      |> where([il], il.user_id == ^user_id)
      |> select([il], il.item_id)
      |> Repo.all()

    Enum.map(items, fn item ->
      if item.id in liked_ids, do: %{item | liked: true}, else: item
    end)
  end

  def mark_installed(items, _), do: items

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

  def get_item_by_slug(nil), do: nil

  def get_item_by_slug(slug) do
    Repo.get_by(Item, slug: slug, is_approved: true)
  end

  def update_item(%Item{} = item, attrs) do
    item
    |> Item.changeset(attrs)
    |> Repo.update()
  end

  def can_like?(item_id, user_id) when is_binary(user_id) do
    is_nil(get_like(item_id, user_id))
  end

  def can_like?(_, _), do: false

  def can_unlike?(item_id, user_id) when is_binary(user_id) do
    not is_nil(get_like(item_id, user_id))
  end

  def can_unlike?(_, _), do: false

  def get_like(item_id, user_id) when is_binary(item_id) and is_binary(user_id) do
    Repo.get_by(ItemLike, item_id: item_id, user_id: user_id)
  end

  def create_like(item_id, user_id) when is_binary(item_id) and is_binary(user_id) do
    %ItemLike{}
    |> ItemLike.changeset(%{item_id: item_id, user_id: user_id})
    |> Repo.insert()
  end

  def delete_like(item_id, user_id) when is_binary(item_id) and is_binary(user_id) do
    case get_like(item_id, user_id) do
      %ItemLike{} = item ->
        Repo.delete(item)

      nil ->
        :ok
    end
  end
end
