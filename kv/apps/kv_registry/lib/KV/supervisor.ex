defmodule KV.Supervisor do
  use Supervisor

  def add_bucket do
    DynamicSupervisor.start_child(KV.BucketSupervisor, KV.Bucket)
  end

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [
      {DynamicSupervisor, name: KV.BucketSupervisor, strategy: :one_for_one},
      {Task.Supervisor, name: KV.TaskRouter},
      {KV.Registry, name: KV.Registry}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
