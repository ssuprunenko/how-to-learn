defmodule App.Repo.Migrations.CreateItemLikes do
  use Ecto.Migration

  def change do
    create table(:item_likes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :item_id, references(:items, on_delete: :delete_all, type: :binary_id)
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:item_likes, [:item_id])
    create index(:item_likes, [:user_id])

    create(unique_index(:item_likes, [:item_id, :user_id], name: :item_id_user_id_unique_index))
  end
end
