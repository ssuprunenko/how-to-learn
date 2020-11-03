defmodule App.Factory do
  use ExMachina.Ecto, repo: App.Repo

  def section_factory do
    %App.Content.Section{
      name: Faker.StarWars.planet(),
      slug: Faker.Internet.slug(),
      summary: Faker.StarWars.quote()
    }
  end

  def category_factory do
    %App.Content.Category{
      name: Faker.StarWars.planet(),
      slug: Faker.Internet.slug(),
      is_published: true
    }
  end

  def item_factory do
    %App.Content.Item{
      name: Faker.Superhero.name(),
      slug: Faker.Internet.slug(),
      url: Faker.Internet.url(),
      license: :freemium,
      has_trial: true,
      likes: Enum.random(1..1_000),
      is_approved: true,
      section: build(:section)
    }
  end

  def category_item_factory do
    %App.Content.CategoryItem{
      category: build(:category),
      item: build(:item)
    }
  end
end
