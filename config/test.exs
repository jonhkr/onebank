use Mix.Config

config :onebank, OneBank.Repo,
	database: "onebank_test",
	username: "root",
	password: "root",
	hostname: "192.168.99.100",
	port: "32299",
  pool: Ecto.Adapters.SQL.Sandbox

config :bcrypt_elixir, log_rounds: 4
