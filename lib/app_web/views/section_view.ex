defmodule AppWeb.SectionView do
  use AppWeb, :view

  def truncated_info(%{summary: summary}) when is_binary(summary) do
    truncate(summary)
  end

  def truncated_info(%{summary: nil, description: nil}), do: ""
  def truncated_info(%{description: description}), do: truncate(description)

  defp truncate(text) do
    text
    |> Curtail.truncate(length: 130)
    |> raw()
  end

  def sort_items_path(socket, section, nil, sort_by) do
    Routes.live_path(socket, AppWeb.SectionLive, section.slug, sort: sort_by)
  end

  def sort_items_path(socket, section, category, sort_by) do
    Routes.live_path(socket, AppWeb.SectionLive, section.slug, category.slug, sort: sort_by)
  end

  def sort_active_classes(sort_by, sort_by), do: "bg-indigo-50 text-indigo-700"

  def sort_active_classes(_, _) do
    "text-gray-500 hover:text-indigo-600 focus:text-indigo-600"
  end
end
