{:ok, _} = Application.ensure_all_started(:ex_machina)
ExUnit.start(exclude: [:skip])
Faker.start()
Ecto.Adapters.SQL.Sandbox.mode(App.Repo, :manual)
