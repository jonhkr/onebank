defmodule OneBank.Command.WithdrawMoney do

  defstruct user_id: nil, amount: nil

  use Vex.Struct

  validates :user_id, presence: true
  validates :amount, presence: true

  defimpl OneBank.CommandExecutor, for: OneBank.Command.WithdrawMoney do

    alias OneBank.Account

    def execute(command) do
      Account.execute(command)
    end
  end
end


