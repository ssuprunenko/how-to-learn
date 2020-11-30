defmodule AppWeb.SkillLive do
  use AppWeb, :live_view

  alias App.Content
  alias App.Content.{Category, Items, Skill}
  alias AppWeb.SkillView

  def mount(params, %{"user_id" => user_id}, socket) do
    skill =
      params["skill_slug"]
      |> Content.get_skill_by_slug()
      |> Skill.with_latest_items(3)
      |> Skill.with_top_items(3, :year)
      |> Skill.with_items_count()

    categories = Category.with_top_items(skill.id, 3)

    {:ok, assign(socket, skill: skill, categories: categories, user_id: user_id)}
  end

  def render(assigns), do: SkillView.render("skill_live.html", assigns)

  def handle_params(params, _url, socket) do
    skill = socket.assigns.skill
    category = Content.get_category_by_slug(params["category_slug"])
    sort_by = if String.to_atom(params["sort"] || "top") == :top, do: :top, else: :new

    items =
      skill
      |> Items.list_items(category, sort_by)
      |> Items.mark_installed(socket.assigns.user_id)

    # socket =
    #   if is_nil(category) do
    #     IO.puts("push_patch")

    #     push_patch(socket,
    #       to:
    #         Routes.live_path(
    #           socket,
    #           __MODULE__,
    #           skill.slug
    #         )
    #     )
    #   else
    #     socket
    #   end

    {:noreply, assign(socket, category: category, items: items, sort_by: sort_by)}
  end

  def handle_info({:update_item, %{slug: slug} = updated_item, flash}, socket) do
    items =
      Enum.map(socket.assigns.items, fn item ->
        if item.slug == slug, do: updated_item, else: item
      end)

    socket =
      case flash do
        {level, message} ->
          put_flash(socket, level, message)

        _ ->
          socket
      end

    {:noreply, assign(socket, items: items)}
  end
end
