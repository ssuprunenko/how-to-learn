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

      <span class="mt-2 inline-flex rounded-md shadow-sm">
        <%= if @item.liked do %>
          <button
            phx-click="unlike"
            phx-target="<%= @myself %>"
            type="button"
            class="inline-flex items-center px-3 py-2 border border-transparent text-sm leading-5 font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-500 focus:outline-none focus:border-indigo-700 focus:shadow-outline-indigo active:bg-indigo-700 transition ease-in-out duration-150"
          >
            <!-- Heroicon name: heart -->
            <svg class="-ml-1 mr-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
              <path fill-rule="evenodd" d="M3.172 5.172a4 4 0 015.656 0L10 6.343l1.172-1.171a4 4 0 115.656 5.656L10 17.657l-6.828-6.829a4 4 0 010-5.656z" clip-rule="evenodd" />
            </svg>
            <%= @item.likes %>
          </button>
        <% else %>
          <button
            phx-click="like"
            phx-target="<%= @myself %>"
            type="button"
            class="inline-flex items-center px-3 py-2 border border-gray-300 text-sm leading-4 font-medium rounded-md text-gray-700 bg-white hover:text-gray-500 focus:outline-none focus:border-blue-300 focus:shadow-outline-blue active:text-gray-800 active:bg-gray-50 transition ease-in-out duration-150"
          >
            <!-- Heroicon name: heart -->
            <svg  class="-ml-1 mr-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
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
