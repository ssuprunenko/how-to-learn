defmodule AppWeb.SectionLive do
  use AppWeb, :live_view

  alias App.Content
  alias App.Content.{Category, Section}
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
    category = Content.get_category_by_slug(params["category_slug"])
    sort_by = if String.to_atom(params["sort"] || "top") == :top, do: :top, else: :new
    items = Content.list_items(section, category, sort_by)

    # socket =
    #   if is_nil(category) do
    #     IO.puts("push_patch")

    #     push_patch(socket,
    #       to:
    #         Routes.live_path(
    #           socket,
    #           __MODULE__,
    #           section.slug
    #         )
    #     )
    #   else
    #     socket
    #   end

    {:noreply, assign(socket, category: category, items: items, sort_by: sort_by)}
  end
end
