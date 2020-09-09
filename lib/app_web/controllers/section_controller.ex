defmodule AppWeb.SectionController do
  use AppWeb, :controller
  alias App.Content
  alias App.Content.{Category, Section}

  def show(conn, %{"slug" => slug} = _params) do
    case Content.get_section_by_slug(slug) do
      nil ->
        conn
        |> redirect(to: "/english")

      section ->
        section =
          section
          |> Section.with_latest_items(3)
          |> Section.with_top_items(3, :month)

        categories = Category.with_top_items(section.id, 3)

        render(conn, "show.html", section: section, categories: categories)
    end
  end

  def redirector(conn, _) do
    redirect(conn, to: "/english")
  end
end
