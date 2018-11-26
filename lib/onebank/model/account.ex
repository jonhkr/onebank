defmodule OneBank.Account do

  alias OneBank.{
    Command.OpenAccount,
    AccountSchema,
    AccountEventSchema,
    AccountRepo,
    AccountOpenedEvent,
    AccountEvent,
    Repo,
  }

  def execute(%OpenAccount{user_id: user_id, initial_deposit: initial_deposit}) do
    Repo.transaction fn ->
      account = create_account(user_id)

      event = %AccountOpenedEvent{account_id: account.id, initial_deposit: initial_deposit}

      apply_event(account, event)
    end
  end

  defp create_account(user_id) do
    params = %{
      user_id: user_id,
      iban: generate_iban(),
      currency: "USD"
    }

    AccountSchema.changeset(:create, %AccountSchema{}, params)
    |> Repo.insert!
  end

  @spec apply_event(String.t(), AccountEvent.t()) :: term
  defp apply_event(account_id, event) do
    account = AccountSchema
    |> Repo.get(account_id)

    AccountSchema.changeset(:update, account, get_account_state(account, event))
    |> Repo.update!

    event_params = %{
      account_id: account.id,
      type: event.type(),
      meta: event
    }

    AccountEventSchema.changeset(%AccountEventSchema{}, event_params)
    |> Repo.insert!
  end

  defp get_account_state(account, %AccountOpenedEvent{initial_deposit: initial_deposit}) do
    %{balance: account.balance + initial_deposit}
  end

  defp generate_iban() do
    "BR100001"
  end
end
