defmodule OneBank.Event.MoneyWithdrew do

  @enforce_keys([:amount, :version])
  defstruct amount: nil, version: nil
end
