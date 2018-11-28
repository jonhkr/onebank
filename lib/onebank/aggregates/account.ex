defmodule OneBank.Aggregate.Account do

  alias OneBank.{
    Event.AccountOpened,
    Event.MoneyWithdrew,
    IbanProvider}

  alias Ecto.UUID

  defstruct id: nil, iban: nil,
            user_id: nil, version: nil,
            balance: nil, currency: nil,
            uncommited_events: []

  def open_account(user_id, initial_deposit, currency) do
    id = UUID.generate()
    {:ok, iban} = IbanProvider.assign(id)

    event = %AccountOpened{
      account_id: id,
      user_id: user_id,
      currency: currency,
      initial_deposit: initial_deposit,
      iban: iban}

    apply_event(%__MODULE__{}, event)
    |> Map.merge(%{uncommited_events: [event]})
  end

  def withdraw(account, amount) do
    validate_positive_amount(amount)
    validate_has_funds(account, amount)

    event = %MoneyWithdrew{amount: amount, version: account.version + 1}

    apply_event(account, event)
    |> Map.merge(%{uncommited_events: account.uncommited_events ++ [event]})
  end

  def apply_event(account, %AccountOpened{} = event) do
    account
    |> Map.merge(%{
      id: event.account_id,
      iban: event.iban,
      user_id: event.user_id,
      version: event.version,
      balance: event.initial_deposit,
      currency: event.currency})
  end

  def apply_event(account, %MoneyWithdrew{} = event) do
    account
    |> Map.merge(%{
      version: event.version,
      balance: account.balance - event.amount})
  end

  def apply_all(account, events) do
    Enum.reduce(events, account, fn (e, acc) -> apply_event(acc, e) end)
  end

  def load(events) do
    apply_all(%__MODULE__{}, events)
  end

  defp validate_positive_amount(amount) do
    if amount < 0 do
      raise OneBank.ValidationError, details: %{"amount" => "should be greater than 0"}
    end
  end

  defp validate_has_funds(account, amount) do
    if account.balance < amount do
      raise OneBank.InsufficientFundsError, details: %{"available_balance" => account.balance}
    end
  end
end
