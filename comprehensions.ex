l = for {:ok, res} <- [ok: 1, ok: 2, error: 3, ok: 4], rem(res, 2) == 0 do
  res*res
end
IO.puts("#{inspect l}")
