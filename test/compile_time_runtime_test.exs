defmodule CompileTimeRuntimeTest do
  use ExUnit.Case
  doctest CompileTimeRuntime

  test "greets the world" do
    assert CompileTimeRuntime.hello() == :world
  end
end
