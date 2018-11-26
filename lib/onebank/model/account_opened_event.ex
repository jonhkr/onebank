defmodule OneBank.AccountOpenedEvent do
  @behaviour OneBank.AccountEvent

  defstruct account_id: nil, initial_deposit: nil

  @impl OneBank.AccountEvent
  def type, do: :account_opened

end
