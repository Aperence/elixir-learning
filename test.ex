defmodule Exp do
  def pow(_, 0) do
    1
  end

  def pow(x, n) when rem(n, 2) == 0 do
    Exp.pow(x*x, div(n, 2))
  end

  def pow(x, n) do
    x*Exp.pow(x*x, div((n-1), 2))
  end
end

IO.puts(Exp.pow(15, 43))
x = :test
IO.puts(x)
