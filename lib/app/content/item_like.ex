defmodule App.Content.ItemLike do
  use Ecto.Schema
  import Ecto.Changeset
  alias App.Accounts.User
  alias App.Content.Item

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "item_likes" do
    belongs_to :item, Item
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(item_like, attrs) do
    item_like
    |> cast(attrs, [:item_id, :user_id])
    |> validate_required([:item_id, :user_id])
    |> unique_constraint(:item_id, name: :item_id_user_id_unique_index)
  end
end
