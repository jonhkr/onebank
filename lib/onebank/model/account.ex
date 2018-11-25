defmodule OneBank.Account do

  alias OneBank.{
    Command.OpenAccount,
    AccountSchema,
    AccountEventSchema,
    AccountRepo,
    AccountOpenedEvent,
    Repo,
  }

  def execute(%OpenAccount{user_id: user_id, initial_deposit: initial_deposit}) do
    account_params = %{
      user_id: user_id,
      iban: generate_iban(),
      currency: "USD"
    }

    Repo.transaction fn ->
      changeset = AccountSchema.changeset(:create, %AccountSchema{}, account_params)

      account = Repo.insert!(changeset)

      event = %AccountOpenedEvent{
        account_id: account.id,
        initial_deposit: initial_deposit
      }

      event_changeset = AccountEventSchema.changeset(%AccountEventSchema{}, %{
        account_id: account.id,
        type: event.type(),
        meta: event
      })

      account_update = AccountSchema.changeset(:update, account, %{balance: account.balance + event.initial_deposit})

      Repo.update!(account_update)
      Repo.insert!(event_changeset)
    end
  end

  defp generate_iban() do
    "BR100001"
  end
end
