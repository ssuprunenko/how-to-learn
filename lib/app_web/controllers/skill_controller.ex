defmodule AppWeb.SkillController do
  use AppWeb, :controller
  alias App.Content.{Category, Skill}

  def show(%{assigns: %{skill: skill}} = conn, _params) do
    skill =
      skill
      |> Skill.with_latest_items(3)
      |> Skill.with_top_items(3, :month)

    categories = Category.with_top_items(skill.id, 3)

    render(conn, "show.html", skill: skill, categories: categories)
  end
end
