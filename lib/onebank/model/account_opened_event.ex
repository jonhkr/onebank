defmodule OneBank.AccountOpenedEvent do
  @behaviour OneBank.AccountEvent

  defstruct account_id: nil, initial_deposit: nil

  @impl Parser
  def type, do: :account_opened

end
