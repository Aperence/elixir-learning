defmodule Test do
  def example() do
    x = 1..10_000 |> Enum.map(fn (x) -> x*3 end) |> Enum.filter(&(rem(&1, 2) == 0)) |> Enum.sum
    x
  end

  def example_lazy() do
    1..10_000 |> Stream.map(&(&1 * 3)) |> Stream.filter(&(rem(&1, 2) == 0)) |> Enum.sum
  end

  def print_file(filename) do
    file = File.stream!(filename)
    Enum.each(file, fn (line) -> IO.puts(line) end)
  end
end

IO.puts("Result : #{Test.example()}")
IO.puts("Result : #{Test.example_lazy()}")

stream = Stream.cycle([1,2,3,4])
[1,2,3,4,1] = Enum.take(stream, 5)
x = Stream.drop(stream, 5) |> Enum.take(5)
[2,3,4,1,2] = x
#, Test.print_file("test.ex")
