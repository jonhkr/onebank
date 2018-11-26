defmodule OneBank.Command.OpenAccount do

  defstruct user_id: nil, initial_deposit: 1_000

  use Vex.Struct

  validates :user_id, presence: true
  validates :initial_deposit, presence: true

  defimpl OneBank.CommandExecutor, for: OneBank.Command.OpenAccount do

    alias OneBank.Account

    def execute(command) do
      Account.execute(command)
    end
  end
end


