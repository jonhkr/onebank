defmodule OneBank.MoneyWithdrewEvent do
 @behaviour OneBank.AccountEvent

  defstruct account_id: nil, amount: nil

  @impl OneBank.AccountEvent
  def type, do: "money_withdrew"
end
