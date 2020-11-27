defmodule App.Admin.SkillAdmin do
  def form_fields(_) do
    [
      name: nil,
      slug: nil,
      summary: nil,
      logo: %{type: :file}
    ]
  end
end
