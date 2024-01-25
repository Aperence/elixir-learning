defmodule Matrix do

  def reduce_identic(list_symbols) do
    Enum.reduce(list_symbols, :empty,
    fn x, acc ->
      if (x != :empty) do
        x
      else
        acc
      end
    end
  )
  end

  def get_identic_symbol(list) do
    if Enum.all?(list, fn x -> x == List.first(list) end) do
      List.first(list)
    else
      :empty
    end
  end

  def identic_row(matrix) do
    rows = for i <- 0..2 do
      row = Enum.at(matrix, i)
      get_identic_symbol(row)
    end
    reduce_identic(rows)
  end

  def identic_column(matrix) do
    transpose =
      for j <- 0..2 do
        for i <- 0..2 do
          Enum.at(matrix, i) |> Enum.at(j)
        end
      end
    identic_row(transpose)
  end

  def identic_diag(matrix) do
    diag =
      for i <- 0..2 do
          Enum.at(matrix, i) |> Enum.at(i)
      end
    get_identic_symbol(diag)
  end

  def reverse_identic_diag(matrix) do
    diag =
      for i <- 0..2 do
          Enum.at(matrix, 2-i) |> Enum.at(i)
      end
    get_identic_symbol(diag)
  end

  def tictactoe_won(matrix) do
    row = identic_row(matrix)
    column = identic_column(matrix)
    diag = identic_diag(matrix)
    reverse_diag = reverse_identic_diag(matrix)
    winner = reduce_identic([row, column, diag, reverse_diag])
    winner
  end
end

sol = Matrix.tictactoe_won([
  [:x, :x, :o],
  [:x, :o, :empty],
  [:o, :empty, :empty]
])

IO.inspect(sol)
