defmodule App.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :slug, :string
      add :is_published, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:categories, [:slug])
  end
end
