defmodule App.Admin.CategoryAdmin do
  def plural_name(_) do
    "Categories"
  end

  def index(_) do
    [
      id: nil,
      name: nil,
      slug: nil,
      is_published: nil,
      inserted_at: nil
    ]
  end

  def form_fields(_) do
    [
      name: nil,
      slug: nil,
      is_published: nil
    ]
  end
end
