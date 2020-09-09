defmodule App.Admin.CategoryAdmin do
  def plural_name(_) do
    "Categories"
  end

  def form_fields(_) do
    [
      name: nil,
      slug: nil,
      is_published: nil
    ]
  end
end
