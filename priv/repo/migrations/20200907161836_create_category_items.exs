defmodule App.Repo.Migrations.CreateCategoryItems do
  use Ecto.Migration

  def change do
    create table(:category_items, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :category_id, references(:categories, on_delete: :delete_all, type: :binary_id)
      add :item_id, references(:items, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:category_items, [:category_id])
    create index(:category_items, [:item_id])

    create(
      unique_index(:category_items, [:category_id, :item_id],
        name: :category_id_item_id_unique_index
      )
    )
  end
end
