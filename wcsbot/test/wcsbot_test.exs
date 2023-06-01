defmodule WcsbotTest do
  use ExUnit.Case
  doctest Wcsbot

  test "greets the world" do
    assert Wcsbot.hello() == :world
  end
end
