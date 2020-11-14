defmodule AppWeb.ItemComponent do
  use AppWeb, :live_component
  alias App.Content
  alias App.Content.Item
  alias AppWeb.SectionView

  def mount(socket) do
    {:ok, socket}
  end

  def render(assigns), do: SectionView.render("item_component.html", assigns)

  def handle_event("like", _params, socket) do
    with %Item{} = item <- socket.assigns.item,
         {:ok, item} <- Content.update_item(item, %{likes: item.likes + 1}) do
      send(self(), {:update_item, %{item | liked: true}})
      {:noreply, socket}
    end
  end

  def handle_event("unlike", _params, socket) do
    with %Item{} = item <- socket.assigns.item,
         {:ok, item} <- Content.update_item(item, %{likes: item.likes - 1}) do
      send(self(), {:update_item, %{item | liked: false}})
      {:noreply, socket}
    end
  end
end
