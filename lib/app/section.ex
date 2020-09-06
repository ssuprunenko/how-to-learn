defmodule App.Section do
  @sections [
    %{id: "english", name: "English"}
  ]

  def find(id) do
    Enum.find(@sections, fn item -> item.id == id end)
  end
end
