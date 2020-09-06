defmodule AppWeb.SectionController do
  use AppWeb, :controller
  alias App.Section

  def show(conn, %{"id" => id} = _params) do
    case Section.find(id) do
      nil ->
        conn
        |> redirect(to: "/english")

      section ->
        render(conn, "show.html", section: section)
    end
  end
end
