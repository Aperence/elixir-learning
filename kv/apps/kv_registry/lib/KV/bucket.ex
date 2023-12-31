defmodule KV.Bucket do
  use Agent, restart: :temporary

  def start(_opts) do
    Agent.start(fn -> %{} end)
  end

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end)
  end

  def get(bucket, key) do
    Agent.get(bucket, &Map.get(&1, key))
  end

  def put(bucket, key, value) do
    Agent.update(bucket, &Map.put(&1, key, value))
  end
end
