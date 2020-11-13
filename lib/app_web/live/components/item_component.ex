defmodule AppWeb.ItemComponent do
  use AppWeb, :live_component

  def mount(socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <div>
      <h3 class="font-semibold"><%= @item.name %></h3>
      <p><%= raw(@item.summary) %></p>
      <p class="mt-2 text-sm leading-5">
        <span class="px-2 py-1 font-medium text-green-800 bg-green-100 rounded"><%= @item.license |> to_string() |> String.capitalize() %></span>
        <%= if @item.has_trial do %>
          (Free Trial)
        <% end %>
      </p>
      <p class="mt-2 text-sm text-gray-600">
        Added <%= Timex.format!(@item.inserted_at, "%F", :strftime) %>
      </p>

      <span class="inline-flex mt-2 rounded-md shadow-sm">
        <%= if @item.liked do %>
          <button
            phx-click="unlike"
            phx-target="<%= @myself %>"
            type="button"
            class="inline-flex items-center px-3 py-2 text-sm font-medium leading-5 text-white transition duration-100 ease-in-out bg-indigo-600 border border-transparent rounded-md hover:bg-indigo-500 focus:outline-none focus:border-indigo-700 focus:shadow-outline-indigo active:bg-indigo-700"
          >
            <!-- Heroicon name: heart -->
            <svg class="w-5 h-5 mr-2 -ml-1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
              <path fill-rule="evenodd" d="M3.172 5.172a4 4 0 015.656 0L10 6.343l1.172-1.171a4 4 0 115.656 5.656L10 17.657l-6.828-6.829a4 4 0 010-5.656z" clip-rule="evenodd" />
            </svg>
            <%= @item.likes %>
          </button>
        <% else %>
          <button
            phx-click="like"
            phx-target="<%= @myself %>"
            type="button"
            class="inline-flex items-center px-3 py-2 text-sm font-medium leading-4 text-gray-700 transition duration-100 ease-in-out bg-white border border-gray-300 rounded-md hover:text-gray-500 focus:outline-none focus:border-blue-300 focus:shadow-outline-blue active:text-gray-800 active:bg-gray-50"
          >
            <!-- Heroicon name: heart -->
            <svg  class="w-5 h-5 mr-2 -ml-1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
              <path fill-rule="evenodd" d="M3.172 5.172a4 4 0 015.656 0L10 6.343l1.172-1.171a4 4 0 115.656 5.656L10 17.657l-6.828-6.829a4 4 0 010-5.656z" clip-rule="evenodd" />
            </svg>
            <%= @item.likes %>
          </button>
        <% end %>
      </span>
    </div>
    """
  end

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
