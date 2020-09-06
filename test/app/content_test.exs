defmodule App.ContentTest do
  use App.DataCase

  alias App.Content

  describe "categories" do
    test "list_categories/0 returns all categories" do
      # category = category_fixture()
      assert Content.list_categories() == []
    end

    test "get_category!/1 returns the category with given id" do
      # category = category_fixture()
      refute Content.get_category(Ecto.UUID.generate())
    end
  end
end
