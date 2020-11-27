defmodule AppWeb.Plugs.SetSkill do
  import Plug.Conn
  alias App.Content

  def init(opts), do: opts

  def call(%Plug.Conn{params: %{"skill_slug" => "all"}} = conn, _opts), do: conn

  def call(%Plug.Conn{params: %{"skill_slug" => slug}} = conn, _opts) do
    case Content.get_skill_by_slug(slug) do
      nil ->
        redirect_to_default(conn)

      skill ->
        assign(conn, :skill, skill)
    end
  end

  def call(conn, _opts), do: redirect_to_default(conn)

  def redirect_to_default(conn) do
    conn
    |> Phoenix.Controller.redirect(to: AppWeb.Router.Helpers.home_path(conn, :index))
    |> halt()
  end
end
