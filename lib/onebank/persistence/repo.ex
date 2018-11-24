defmodule OneBank.Repo do
  use Ecto.Repo,
    otp_app: :onebank,
    adapter: Ecto.Adapters.MySQL
end
