defmodule App.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    LicenseEnum.create_type()

    create table(:items, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :slug, :string, null: false
      add :url, :string
      add :summary, :text
      add :description, :text
      add :author, :string
      add :author_url, :string
      add :license, LicenseEnum.type()
      add :has_trial, :boolean, default: false, null: false
      add :likes, :integer, default: 0
      add :section_id, references(:sections, on_delete: :nothing, type: :binary_id)
      add :is_approved, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:items, [:slug])
    create index(:items, [:section_id])
  end
end
