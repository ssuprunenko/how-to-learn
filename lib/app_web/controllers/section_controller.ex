defmodule AppWeb.SectionController do
  use AppWeb, :controller
  alias App.Content.{Category, Section}

  def show(%{assigns: %{section: section}} = conn, _params) do
    section =
      section
      |> Section.with_latest_items(3)
      |> Section.with_top_items(3, :month)

    categories = Category.with_top_items(section.id, 3)

    render(conn, "show.html", section: section, categories: categories)
  end
end
