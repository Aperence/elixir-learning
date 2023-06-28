defmodule KVServer.Command do
    def parse(line) do
        case String.split(line) do
          ["CREATE", collection] -> {:ok, {:create, collection}}
          ["PUT", collection, key, value] -> {:ok, {:put, collection, key, value}}
          ["GET", collection, key] -> {:ok, {:get, collection, key}}
          _ -> {:error, :unknown}
        end
    end

    def run(command)

    def run({:create, collection}) do
      case KV.Router.route(collection, KV.Registry, :create, [KV.Registry, collection]) do
        :ok -> {:ok, "OK\r\n"}
        _ -> {:error, "FAILED TO CREATE BUCKET\r\n"}
      end
    end

    def run({:put, collection, key, value}) do
      lookup(collection, fn (bucket) ->
        KV.Bucket.put(bucket, key, value)
        {:ok, "OK\r\n"}
      end)
    end

    def run({:get, collection, key}) do
      lookup(collection, fn (bucket) ->
        res = KV.Bucket.get(bucket, key)
        {:ok, "#{res}\r\nOK\r\n"}
      end)
    end

    defp lookup(collection, callback) do
      case KV.Router.route(collection, KV.Registry, :lookup, [KV.Registry, collection]) do
        {:ok, bucket} -> callback.(bucket)
        :error -> {:error, "INTERNAL ERROR\r\n"}
      end
    end
end
