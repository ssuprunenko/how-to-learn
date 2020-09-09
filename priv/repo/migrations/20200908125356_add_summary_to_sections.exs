defmodule App.Repo.Migrations.AddSummaryToSections do
  use Ecto.Migration

  def change do
    alter table(:sections) do
      add :summary, :text
    end
  end
end
