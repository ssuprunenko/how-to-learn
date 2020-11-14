defmodule AppWeb.ItemComponent do
  use AppWeb, :live_component
  alias AppWeb.SectionView

  def mount(socket) do
    {:ok, socket}
  end

  def render(assigns), do: SectionView.render("item_component.html", assigns)

  def handle_event("like", _params, socket) do
    item = socket.assigns.item

    send(
      self(),
      {:update_item, %{item | likes: item.likes + 1, liked: true}}
    )

    {:noreply, socket}
  end

  def handle_event("unlike", _params, socket) do
    item = socket.assigns.item

    send(
      self(),
      {:update_item, %{item | likes: item.likes - 1, liked: false}}
    )

    {:noreply, socket}
  end
end
