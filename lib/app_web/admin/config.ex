defmodule App.Admin.Config do
  def create_resources(_conn) do
    [
      content: [
        resources: [
          skill: [schema: App.Content.Skill],
          category: [schema: App.Content.Category, admin: App.Admin.CategoryAdmin],
          item: [schema: App.Content.Item, admin: App.Admin.ItemAdmin],
          category_item: [
            schema: App.Content.CategoryItem,
            admin: App.Admin.CategoryItemAdmin
          ]
        ]
      ],
      accounts: [
        resources: [
          user: [schema: App.Accounts.User, admin: App.Admin.UserAdmin],
          item_like: [schema: App.Content.ItemLike, admin: App.Admin.ItemLikeAdmin]
        ]
      ]
    ]
  end
end
