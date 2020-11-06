defmodule AppWeb.SectionLive do
  use AppWeb, :live_view

  alias App.{Content, Repo}
  alias App.Content.{Category, Item, Section}
  alias AppWeb.SectionView

  def mount(params, _session, socket) do
    section =
      params["section_slug"]
      |> Content.get_section_by_slug()
      |> Section.with_latest_items(3)
      |> Section.with_top_items(3, :year)
      |> Section.with_items_count()

    categories = Category.with_top_items(section.id, 3)

    {
      :ok,
      assign(socket, section: section, categories: categories),
      temporary_assigns: [items: []]
    }
  end

  def render(assigns), do: SectionView.render("show_live.html", assigns)

  def handle_params(params, _url, socket) do
    section = socket.assigns.section

    socket =
      case Content.get_category_by_slug(params["category_slug"]) do
        nil ->
          items =
            section.id
            |> Item.approved_by_section_query()
            |> Item.top_by_likes_query(20)
            |> Repo.all()

          socket = assign(socket, category: nil, items: items)

          if params["category_slug"] do
            push_patch(socket,
              to:
                Routes.live_path(
                  socket,
                  __MODULE__,
                  section.slug
                )
            )
          else
            socket
          end

        category ->
          items =
            section.id
            |> Item.approved_by_section_query()
            |> Item.with_category_query()
            |> Item.top_by_likes_query(20)
            |> Repo.all()
            |> Enum.filter(fn item -> item.category.slug == category.slug end)

          assign(socket, category: category, items: items)
      end

    {:noreply, socket}
  end
end
