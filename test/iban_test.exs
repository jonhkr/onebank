defmodule OneBank.IbanTest do
  use ExUnit.Case
  alias OneBank.{Repo, IbanProvider}

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  test "assign iban" do
    account_id = Ecto.UUID.generate()
    {:ok, number} = IbanProvider.assign(account_id)

    assert number != nil
  end

  test "retrieve assigned account_id" do
    account_id = Ecto.UUID.generate()
    {:ok, number} = IbanProvider.assign(account_id)

    iban = IbanProvider.retrieve(number)

    assert account_id == iban.account_id
  end

  test "retrieve unknown" do
    id = IbanProvider.retrieve("abc")

    assert id == nil
  end
end
