defmodule OneBank.AccountTest do
  use ExUnit.Case
  alias OneBank.{
    Repo,
    UserRepo,
    Command.OpenAccount,
    Command.CreateUser,
    Account
  }

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  test "create account" do
    create_user = %CreateUser{
      name: "Jonas Trevisan",
      username: "jonast",
      raw_password: "foobar"}

    {:ok, user} = UserRepo.create(create_user)

    Account.execute(%OpenAccount{user_id: user.id, initial_deposit: 1_000})
  end

end
