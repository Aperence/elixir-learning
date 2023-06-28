defmodule KV.Router do
    def route(bucket, mod, fun, args) do
        byte = :binary.first(bucket)
        next =
          table()
          |> Enum.find(fn ({key, _value}) -> byte in key end)
          |> elem(1)

        if next == node() do
          apply(mod, fun, args)
        else
          {KV.TaskRouter, next}
          |> Task.Supervisor.async(KV.Router, :route, [bucket, mod, fun, args])
          |> Task.await()
        end
    end

    def table() do
      Application.fetch_env!(:kv_registry, :routing_table)
    end
end
