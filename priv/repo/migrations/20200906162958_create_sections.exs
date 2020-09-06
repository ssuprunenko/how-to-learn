defmodule App.Repo.Migrations.CreateSections do
  use Ecto.Migration

  def change do
    create table(:sections, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :slug, :string

      timestamps()
    end

    create unique_index(:sections, [:slug])
  end
end
