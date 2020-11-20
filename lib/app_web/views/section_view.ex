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

  def sort_active_classes(sort_by, sort_by), do: "bg-gray-300 text-black"

  def sort_active_classes(_, _) do
    "text-gray-600 hover:text-gray-700 focus:text-gray-700"
  end

  def logo_url(%{logo: nil} = item, version) do
    App.Uploaders.Logo.url({nil, item}, version)
  end

  def logo_url(item, version) do
    "/assets" <> App.Uploaders.Logo.url({item.logo, item}, version)
  end
end
