defmodule AppWeb.CategoryController do
  use AppWeb, :controller
  alias App.Content

  def show(%{assigns: %{section: section}} = conn, %{"slug" => slug} = _params) do
    case Content.get_category_by_slug(slug) do
      nil ->
        redirect(conn, to: Routes.section_path(conn, :show, section.slug))

      category ->
        render(conn, "show.html", category: category)
    end
  end
end
