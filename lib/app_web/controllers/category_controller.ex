defmodule AppWeb.CategoryController do
  use AppWeb, :controller
  alias App.Content
  alias App.Content.Item
  alias App.Repo

  def show(%{assigns: %{section: section}} = conn, %{"slug" => slug} = _params) do
    case Content.get_category_by_slug(slug) do
      nil ->
        redirect(conn, to: Routes.section_path(conn, :show, section.slug))

      category ->
        items =
          section.id
          |> Item.approved_by_section_query()
          |> Item.with_category_query()
          |> Item.top_by_likes_query(20)
          |> Repo.all()
          |> Enum.filter(fn item -> item.category.slug == category.slug end)

        render(conn, "show.html", category: category, items: items)
    end
  end
end
