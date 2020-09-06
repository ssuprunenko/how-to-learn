defmodule App.Admin.Config do
  def create_resources(_conn) do
    [
      content: [
        resources: [
          category: [schema: App.Content.Category, admin: App.Admin.Category]
        ]
      ]
    ]
  end
end
