defmodule DomainCheckerTest do
  use ExUnit.Case
  doctest DomainChecker

  test "greets the world" do
    assert DomainChecker.hello() == :world
  end
end
