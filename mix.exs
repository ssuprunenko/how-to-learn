defmodule App.MixProject do
  use Mix.Project

  def project do
    [
      app: :app,
      version: "0.1.0",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {App.Application, []},
      extra_applications: [:logger, :runtime_tools, :os_mon]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5.4"},

      # PostgreSQL
      {:phoenix_ecto, "~> 4.1"},
      {:ecto_sql, "~> 3.4"},
      {:ecto_enum, "~> 1.4"},
      {:postgrex, ">= 0.0.0"},

      # Assets
      {:waffle, "~> 1.1.3"},
      {:waffle_ecto, "~> 0.0.9"},

      # Time helpers
      {:timex, "~> 3.6"},

      # Live View
      {:phoenix_live_view, "~> 0.14.7"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_dashboard, "~> 0.3"},
      {:curtail, "~> 2.0"},

      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.4"},

      # Admin
      {:kaffy, git: "https://github.com/aesmail/kaffy"},

      # Auth
      {:phx_gen_auth, "~> 0.5", only: [:dev], runtime: false},
      {:argon2_elixir, "~> 2.0"},

      # Error monitoring
      {:sentry, "~> 8.0"},

      {:phoenix_live_reload, "~> 1.2", only: :dev},

      {:floki, ">= 0.27.0", only: :test},
      {:ex_machina, "~> 2.4", only: :test},
      {:faker, "~> 0.14", only: :test},
      {:assert_html, "~> 0.1.2", only: :test},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "cmd npm install --prefix assets"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
