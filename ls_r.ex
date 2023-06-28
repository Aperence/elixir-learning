defmodule LS do

    def ls_r(path) do
      case File.regular?(path) do
        true -> [path]
        false ->
          File.ls!(path)
          |> Enum.map(&Path.join(path, &1))
          |> Enum.map(&ls_r(&1))
          |> Enum.concat()
      end
    end
end

res = LS.ls_r("./test")
IO.puts("Result : #{inspect res}")
