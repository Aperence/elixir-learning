defmodule RegistryTest do
  use ExUnit.Case, async: true
  doctest KV.Registry
  alias KV.Registry
  alias KV.Bucket

  setup context do
    _ = start_supervised!({Registry, [name: context.test]})
    %{registry: context.test}
  end

  test "run bucket", %{registry: registry} do
    assert Registry.lookup(registry, "tools") == :error

    Registry.create(registry, "tools")

    {:ok, bucket} = Registry.lookup(registry, "tools")

    res = Bucket.get(bucket, "hello")
    assert res == nil

    Bucket.put(bucket, "hello", "world")
    res = Bucket.get(bucket, "hello")
    assert res == "world"
  end

  test "error bucket", %{registry: registry}  do
    Registry.create(registry, "tools")

    {:ok, bucket} = Registry.lookup(registry, "tools")

    Process.exit(bucket, :error)

    Process.sleep(200)

    ret = Registry.lookup(Registry, "tools")
    assert ret == :error
  end
end
