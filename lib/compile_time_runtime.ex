defmodule CompileTimeRuntime do
  @moduledoc """
  Documentation for CompileTimeRuntime.
  """

  IO.puts("I'M EVALUATED AND EXECUTED AT COMPILE TIME")


  @doc """
  This function intentionally contains invalid code. When executed, it is
  evaluated at runtime.
  """
  def hello do
    IO.puts("I'M EXECUTED AT RUN TIME")

    foo = fn
      (1, x) -> x
      (2, x) -> x + 10
    end
    foo.(3, 100)
  end
end
