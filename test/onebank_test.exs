defmodule OneBankTest do
  use ExUnit.Case
  doctest OneBank

  test "greets the world" do
    assert OneBank.hello() == :world
  end
end
