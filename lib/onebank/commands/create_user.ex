defmodule OneBank.Command.CreateUser do

  defstruct name: nil, username: nil, raw_password: nil

  use Vex.Struct

  validates :name, presence: true
  validates :username, presence: true,
                       length: [min: 4]
  validates :raw_password, presence: true,
                           length: [min: 6]
end