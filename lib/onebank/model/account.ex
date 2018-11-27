defmodule OneBank.Account do

  alias OneBank.{
    Command.OpenAccount,
    Command.WithdrawMoney,
    AccountSchema,
    AccountEventSchema,
    AccountOpenedEvent,
    MoneyWithdrewEvent,
    AccountEvent,
    Repo,
  }

  def execute(%OpenAccount{user_id: user_id, initial_deposit: initial_deposit}) do
    result = Repo.transaction fn ->
      account = create_account(user_id, "USD")

      event = %AccountOpenedEvent{account_id: account.id, initial_deposit: initial_deposit}

      apply_event(account, event)
    end

    case result do
      {:ok, event} -> event
      {:error, _} -> raise "Failed" # TODO: handle this
    end
  end

  def execute(%WithdrawMoney{user_id: user_id, amount: amount}) do
    result = Repo.transaction fn ->
      account = get_account(user_id, "USD")

      event = %MoneyWithdrewEvent{account_id: account.id, amount: amount}

      apply_event(account, event)
    end

    case result do
      {:ok, event} -> event
      {:error, _} -> raise "Failed" # TODO: handle this
    end
  end

  defp create_account(user_id, currency) do
    params = %{
      user_id: user_id,
      iban: generate_iban(),
      currency: currency
    }

    AccountSchema.changeset(:create, %AccountSchema{}, params)
    |> Repo.insert!
  end

  @spec apply_event(AccountSchema.t(), AccountEvent.t()) :: term
  defp apply_event(account, event) do
    AccountSchema.changeset(:update, account, get_account_state(account, event))
    |> Repo.update!

    event_params = %{
      account_id: account.id,
      type: event.__struct__.type(),
      meta: Map.from_struct(event)
    }

    AccountEventSchema.changeset(%AccountEventSchema{}, event_params)
    |> Repo.insert!
  end

  defp get_account_state(account, %AccountOpenedEvent{initial_deposit: initial_deposit}) do
    %{balance: Decimal.add(account.balance, initial_deposit)}
  end

  defp get_account_state(account, %MoneyWithdrewEvent{amount: amount}) do
    %{balance: Decimal.sub(account.balance, amount)}
  end

  defp generate_iban() do
    "BR100001"
  end

  defp get_account(user_id, currency) do
    AccountSchema
    |> Repo.get_by([user_id: user_id, currency: "USD"])
  end
end
