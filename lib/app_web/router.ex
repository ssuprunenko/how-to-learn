defmodule AppWeb.Router do
  use AppWeb, :router
  use Kaffy.Routes, scope: "/admin", pipe_through: [:admin_basic_auth]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {AppWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :admins_only do
    plug :admin_basic_auth
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:prod, :dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:browser, :admins_only]
      live_dashboard "/dashboard", metrics: AppWeb.Telemetry
    end
  end

  scope "/", AppWeb do
    pipe_through :browser

    # live "/", PageLive, :index
    get "/", SectionController, :redirector

    resources "/", SectionController, name: "section", param: "slug", only: [:show] do
      resources "/categories", CategoryController, param: "slug", only: [:show]
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", AppWeb do
  #   pipe_through :api
  # end

  defp admin_basic_auth(conn, _opts) do
    Plug.BasicAuth.basic_auth(conn, Application.get_env(:app, :basic_auth))
  end
end
