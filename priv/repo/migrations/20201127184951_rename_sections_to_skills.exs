defmodule App.Repo.Migrations.RenameSectionsToSkills do
  use Ecto.Migration

  def change do
    rename table("sections"), to: table("skills")

    rename table("items"), :section_id, to: :skill_id
    drop index("items", [:section_id])
    create index("items", [:skill_id])
  end
end
