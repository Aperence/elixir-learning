defmodule KV.Registry do
  use GenServer

  def start_link(opts) do
    {:ok, name} = Keyword.fetch(opts, :name)
    GenServer.start_link(__MODULE__, name, opts)
  end

  def create(server, collection) do
    GenServer.call(server, {:create, collection})
  end

  def lookup(server, collection) do
    case :ets.lookup(server, collection) do
      [{^collection, pid}] -> {:ok, pid}
      [] -> :error
    end
  end

  def init(name) do
    table = :ets.new(name, [:named_table, read_concurrency: true])
    {:ok, [table: table, references: %{}]}
  end

  def handle_call({:create, name}, _from, table: table, references: refs) do
    {:ok, bucket} = KV.Supervisor.add_bucket()
    ref = Process.monitor(bucket)
    :ets.insert(table, {name, bucket})
    {:reply, :ok, [table: table, references: Map.put(refs, ref, name)]}
  end

  def handle_call({:lookup, name}, _from, state = [table: table, references: _refs]) do
    case :ets.lookup(table, name) do
      [{^name, res}] -> {:reply, {:ok, res}, state}
      _ -> {:reply, :error, state}
    end
  end

  def handle_info({:DOWN, ref, :process, _pid , _reason}, [table: table, references: refs]) do
    {name, new_refs} = Map.pop(refs, ref)
    :ets.delete(table, name)
    {:noreply, [table: table, references: new_refs]}
  end

  def handle_info(msg, state) do
    require Logger
    Logger.log(0, "Unexpected message #{msg}")
    {:noreply, state}
  end
end
