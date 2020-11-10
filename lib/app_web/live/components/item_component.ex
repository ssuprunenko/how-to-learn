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
      <p class="mt-2 italic"><%= "#{@item.likes} likes" %></p>
    </div>
    """
  end
end
