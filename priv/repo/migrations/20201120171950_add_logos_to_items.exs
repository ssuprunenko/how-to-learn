defmodule App.Repo.Migrations.AddLogosToItems do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add :logo, :string
    end
  end
end
