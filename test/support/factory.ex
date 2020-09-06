defmodule App.Factory do
  use ExMachina.Ecto, repo: App.Repo

  def section_factory do
    %App.Content.Section{
      name: "English",
      slug: "english"
    }
  end

  def category_factory do
    %App.Content.Category{
      name: "Apps",
      slug: "apps",
      is_published: true
    }
  end
end
