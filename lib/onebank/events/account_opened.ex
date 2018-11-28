defmodule OneBank.Event.AccountOpened do

  @enforce_keys([:account_id, :user_id, :currency, :iban])
  defstruct account_id: nil, user_id: nil, initial_deposit: 1_000, currency: nil, iban: nil, version: 1
end
