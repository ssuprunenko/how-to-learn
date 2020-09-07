defmodule App.Admin.ItemAdmin do
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
      is_approved: nil
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
end
