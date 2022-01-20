defmodule DynHacksTest do
  use ExUnit.Case
  doctest DynHacks

  test "greets the world" do
    assert DynHacks.hello() == :world
  end
end
