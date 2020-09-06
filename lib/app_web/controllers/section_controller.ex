defmodule AppWeb.SectionController do
  use AppWeb, :controller
  alias App.Content

  def show(conn, %{"slug" => slug} = _params) do
    case Content.get_section_by_slug(slug) do
      nil ->
        conn
        |> redirect(to: "/english")

      section ->
        render(conn, "show.html", section: section)
    end
  end
end
