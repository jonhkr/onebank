defmodule OneBank.Command.CreateSession do

  defstruct username: nil, raw_password: nil

  use Vex.Struct

  validates :username, presence: true
  validates :raw_password, presence: true
end