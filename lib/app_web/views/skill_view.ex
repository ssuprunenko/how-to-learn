defmodule AppWeb.SkillView do
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

  def sort_items_path(socket, skill, nil, sort_by) do
    Routes.live_path(socket, AppWeb.SkillLive, skill.slug, sort: sort_by)
  end

  def sort_items_path(socket, skill, category, sort_by) do
    Routes.live_path(socket, AppWeb.SkillLive, skill.slug, category.slug, sort: sort_by)
  end

  def sort_active_classes(sort_by, sort_by), do: "bg-gray-200 text-gray-900"

  def sort_active_classes(_, _) do
    "text-gray-500"
  end

  def logo_url(%{logo: nil} = item, version) do
    App.Uploaders.Logo.url({nil, item}, version)
  end

  def logo_url(item, version) do
    url =
      {item.logo, item}
      |> App.Uploaders.Logo.url(version)
      |> String.replace("v=", "vsn=")

    "/assets" <> url
  end
end
