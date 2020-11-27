defmodule AppWeb.Plugs.SetItem do
  import Plug.Conn
  alias App.Content.Items

  def init(opts), do: opts

  def call(%Plug.Conn{params: %{"slug" => slug}} = conn, _opts) do
    case Items.get_item_by_slug(slug) do
      nil ->
        redirect_to_default(conn)

      item ->
        assign(conn, :item, item)
    end
  end

  def call(conn, _opts), do: redirect_to_default(conn)

  def redirect_to_default(conn) do
    conn
    |> Phoenix.Controller.redirect(
      to: AppWeb.Router.Helpers.live_path(conn, AppWeb.SkillLive, "english")
    )
    |> halt()
  end
end
