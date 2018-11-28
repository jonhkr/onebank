defmodule OneBank.AccountTest do
  use ExUnit.Case
  alias OneBank.{
    Aggregate.Account,
    IbanProvider,
    Repo,
    AccountRepo
  }

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  test "create account" do
    user_id = Ecto.UUID.generate()
    initial_deposit = 1_000
    currency = "BRL"

    account = Account.open_account(user_id, initial_deposit, currency)

    assert account.id != nil
    assert account.user_id == user_id
    assert account.balance == initial_deposit
    assert account.currency == currency
    assert account.version == 1
    assert length(account.uncommited_events) == 1

    [event] = account.uncommited_events

    assert event.account_id == account.id
    assert event.initial_deposit == account.balance
    assert event.currency == account.currency
    assert event.version == 1
    assert event.user_id == user_id
    assert event.iban == account.iban

    iban = IbanProvider.retrieve(account.iban)

    assert account.id == iban.account_id
  end

  test "withdraw money" do
    user_id = Ecto.UUID.generate()
    initial_deposit = 10
    currency = "BRL"

    account = Account.open_account(user_id, initial_deposit, currency)
    |> Account.withdraw(5)

    assert account.balance == 5
    assert account.version == 2
    assert length(account.uncommited_events) == 2
  end

  test "store account" do
    user_id = Ecto.UUID.generate()
    initial_deposit = 10
    currency = "BRL"

    account = Account.open_account(user_id, initial_deposit, currency)
    |> Account.withdraw(5)

    AccountRepo.store(account)

    loaded = AccountRepo.load(Account, account.id)

    assert account.id == loaded.id
    assert account.iban == loaded.iban
    assert account.user_id == loaded.user_id
    assert account.version == loaded.version
    assert account.balance == loaded.balance
    assert account.currency == loaded.currency
  end

  test "update stale account" do
    user_id = Ecto.UUID.generate()
    initial_deposit = 10
    currency = "BRL"

    account = Account.open_account(user_id, initial_deposit, currency)

    AccountRepo.store(account)

    account = AccountRepo.load(Account, account.id)

    account1 = Account.withdraw(account, 5)

    AccountRepo.store(account1)

    account2 = Account.withdraw(account, 2)

    assert_raise Ecto.ConstraintError, fn ->
      AccountRepo.store(account2)
    end

    account = AccountRepo.load(Account, account.id)

    assert account.balance == 5
  end
end
