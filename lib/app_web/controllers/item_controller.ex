defmodule AppWeb.ItemController do
  use AppWeb, :controller

  def away(%{assigns: %{item: item}} = conn, _params) do
    conn
    |> put_status(:moved_permanently)
    |> redirect(external: item.url)
  end
end
