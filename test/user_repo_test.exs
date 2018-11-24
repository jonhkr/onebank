defmodule OneBank.UserRepoTest do
  use ExUnit.Case
  alias OneBank.{Repo, UserRepo, Command.CreateUser}

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  test "create user" do
    command = %CreateUser{
      name: "Jonas Trevisan",
      username: "jonast",
      raw_password: "foobar"}

    {:ok, user} = UserRepo.create(command)

    assert user.name == command.name
    assert user.username == command.username
    assert Comeonin.Bcrypt.checkpw(command.raw_password, user.password_hash)
  end

  test "create user with username already taken" do
    command = %CreateUser{
      name: "Jonas Trevisan",
      username: "jonast",
      raw_password: "foobar"}

    {:ok, user} = UserRepo.create(command)

    assert user.name == command.name
    assert user.username == command.username
    assert Comeonin.Bcrypt.checkpw(command.raw_password, user.password_hash)

    assert_raise Ecto.ConstraintError, fn ->
      UserRepo.create(command)
    end
  end
end
