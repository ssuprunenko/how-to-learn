defmodule App.Repo.Migrations.AddLogosToSkills do
  use Ecto.Migration

  def change do
    alter table(:skills) do
      add :logo, :string
    end
  end
end
