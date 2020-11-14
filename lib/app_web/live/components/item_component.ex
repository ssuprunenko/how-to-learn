defmodule AppWeb.ItemComponent do
  use AppWeb, :live_component
  alias App.Content.Items
  alias AppWeb.SectionView

  def mount(socket) do
    {:ok, socket}
  end

  def render(assigns), do: SectionView.render("item_component.html", assigns)

  def handle_event("like", _params, %{assigns: %{item: item, user_id: user_id}} = socket)
      when is_binary(user_id) do
    with true <- Items.can_like?(item.id, user_id),
         {:ok, _} <- Items.create_like(item.id, user_id),
         {:ok, item} <- Items.update_item(item, %{likes: item.likes + 1}) do
      send(self(), {:update_item, %{item | liked: true}, nil})
      {:noreply, socket}
    end
  end

  def handle_event("like", _params, %{assigns: %{item: item, user_id: nil}} = socket) do
    send(
      self(),
      {
        :update_item,
        %{item | likes: item.likes + 1, liked: true},
        {:info, "Log in or register to save your likes"}
      }
    )

    {:noreply, socket}
  end

  def handle_event("unlike", _params, %{assigns: %{item: item, user_id: user_id}} = socket)
      when is_binary(user_id) do
    with true <- Items.can_unlike?(item.id, user_id),
         {:ok, item} <- Items.update_item(item, %{likes: item.likes - 1}),
         {:ok, _} <- Items.delete_like(item.id, user_id) do
      send(self(), {:update_item, %{item | liked: false}, nil})
      {:noreply, socket}
    end
  end

  def handle_event("unlike", _params, %{assigns: %{item: item, user_id: nil}} = socket) do
    send(self(), {:update_item, %{item | likes: item.likes - 1, liked: false}, nil})
    {:noreply, socket}
  end
end
