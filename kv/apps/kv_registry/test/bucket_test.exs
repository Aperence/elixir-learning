defmodule BucketTest do
  use ExUnit.Case, async: true
  doctest KV.Bucket
  alias KV.Bucket

  setup do
    {:ok, bucket} = Bucket.start_link([])
    %{bucket: bucket}
  end

  test "run bucket", %{bucket: bucket} do

    res = Bucket.get(bucket, "hello")
    assert res == nil

    Bucket.put(bucket, "hello", "world")
    res = Bucket.get(bucket, "hello")
    assert res == "world"
  end
end
