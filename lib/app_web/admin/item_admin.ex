defmodule App.Admin.ItemAdmin do
  import Ecto.Query
  alias App.Content

  def custom_index_query(_conn, _schema, query) do
    from(r in query, preload: [:categories])
  end

  def index(_) do
    [
      id: nil,
      name: nil,
      slug: nil,
      url: nil,
      categories: %{
        value: fn item -> categories(item) end
      },
      section: %{
        value: fn item -> Content.get_section(item.section_id).name end
      },
      is_approved: %{
        filters: [{true, true}, {false, false}]
      },
      summary: %{
        value: fn item -> truncate(item.summary) end
      },
      description: %{
        value: fn item -> truncate(item.description) end
      },
      license: %{
        filters: license_values()
      },
      likes: nil,
      inserted_at: nil,
      updated_at: nil
    ]
  end

  def form_fields(_) do
    [
      name: nil,
      slug: nil,
      url: nil,
      author: nil,
      author_url: %{label: "Author's website"},
      summary: %{label: "Short Summary", type: :richtext},
      description: %{type: :richtext},
      license: %{choices: license_values()},
      has_trial: nil,
      likes: nil,
      section_id: nil,
      is_approved: nil,
      inserted_at: nil
    ]
  end

  defp license_values do
    Enum.map(LicenseEnum.__enum_map__(), fn val ->
      label =
        val
        |> to_string()
        |> String.capitalize()

      {label, val}
    end)
  end

  defp categories(item) do
    item.categories
    |> Enum.map(& &1.name)
    |> Enum.join(", ")
  end

  defp truncate(nil), do: nil

  defp truncate(text) do
    String.slice(text, 0..10) <> "..."
  end
end
