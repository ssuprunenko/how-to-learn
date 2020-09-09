defmodule AppWeb.SectionView do
  use AppWeb, :view

  def truncated_info(%{summary: summary}) when is_binary(summary) do
    truncate(summary)
  end

  def truncated_info(%{summary: nil, description: nil}), do: ""
  def truncated_info(%{description: description}), do: truncate(description)

  defp truncate(text) do
    text
    |> Curtail.truncate(length: 130)
    |> raw()
  end
end
