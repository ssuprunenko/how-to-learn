defmodule AppWeb.Plugs.SetSection do
  import Plug.Conn
  alias App.Content

  def init(opts), do: opts

  def call(%Plug.Conn{params: %{"section_slug" => slug}} = conn, _opts) do
    case Content.get_section_by_slug(slug) do
      nil ->
        redirect_to_default(conn)

      section ->
        assign(conn, :section, section)
    end
  end

  def call(conn, _opts), do: redirect_to_default(conn)

  def redirect_to_default(conn) do
    conn
    |> Phoenix.Controller.redirect(to: AppWeb.Router.Helpers.section_path(conn, :show, "english"))
    |> halt()
  end
end
