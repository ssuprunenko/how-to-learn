defmodule App.Admin.UserAdmin do
  def index(_) do
    [
      id: nil,
      email: nil,
      name: nil,
      username: nil,
      confirmed_at: nil,
      inserted_at: nil,
      updated_at: nil
    ]
  end

  def form_fields(_) do
    [
      email: nil,
      name: nil,
      username: nil,
      confirmed_at: nil
    ]
  end
end
