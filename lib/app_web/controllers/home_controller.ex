defmodule AppWeb.HomeController do
  use AppWeb, :controller
  alias App.Content
  alias App.Content.Category

  def index(conn, _) do
    skills = Content.sections_for_homepage()
    categories = Category.with_top_items(nil, 4)

    render(conn, "index.html", skills: skills, categories: categories, page_title: "Home")
  end
end
