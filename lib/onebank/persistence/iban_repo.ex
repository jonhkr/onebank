defmodule OneBank.IbanRepo do
  require Logger

  alias OneBank.{IbanSchema, Repo}

  def assign(account_id) do
    number = Ecto.UUID.generate()

    IbanSchema.changeset(%IbanSchema{}, %{number: number, account_id: account_id})
    |> Repo.insert
  end

  def find_by_number(number) do
    Repo.get_by(IbanSchema, number: number)
  end
end
