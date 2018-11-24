use Mix.Config

config :onebank, OneBank.Repo,
  database: "onebank_test",
  username: "root",
  password: "",
  hostname: "localhost",
  port: "3306",
  pool: Ecto.Adapters.SQL.Sandbox

config :bcrypt_elixir, log_rounds: 4
