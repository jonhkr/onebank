defmodule OneBank.IbanProvider do

  alias OneBank.IbanRepo

  def assign(account_id) do
    case IbanRepo.assign(account_id) do
      {:ok, iban} -> {:ok, iban.number}
      {:error, _} -> :error
    end
  end

  def retrieve(number) do
    IbanRepo.find_by_number(number)
  end
end
