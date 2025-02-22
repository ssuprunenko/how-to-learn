defmodule AppWeb.Router do
  use AppWeb, :router
  use Kaffy.Routes, scope: "/admin", pipe_through: [:admin_basic_auth]
  import AppWeb.Auth.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {AppWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :admins_only do
    plug :admin_basic_auth
  end

  pipeline :require_skill do
    plug AppWeb.Plugs.SetSkill
  end

  pipeline :require_item do
    plug AppWeb.Plugs.SetItem
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only skill yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:prod, :dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:browser, :admins_only]
      live_dashboard "/dashboard", metrics: AppWeb.Telemetry
    end
  end

  ## Authentication routes

  scope "/auth", AppWeb.Auth, as: :auth do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/auth", AppWeb.Auth, as: :auth do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/auth", AppWeb.Auth, as: :auth do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm
  end

  scope "/", AppWeb do
    pipe_through [:browser]

    get "/", HomeController, :index
  end

  scope "/r", AppWeb do
    pipe_through [:browser, :require_item]

    get "/:slug", ItemController, :show
    get "/:slug/away", ItemController, :away, as: :item_away
  end

  scope "/", AppWeb do
    pipe_through [:browser, :require_skill]

    get "/home/:skill_slug", SkillController, :show

    live "/:skill_slug/:category_slug", SkillLive
    live "/:skill_slug", SkillLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", AppWeb do
  #   pipe_through :api
  # end

  defp admin_basic_auth(conn, _opts) do
    Plug.BasicAuth.basic_auth(conn, Application.get_env(:app, :basic_auth))
  end
end
