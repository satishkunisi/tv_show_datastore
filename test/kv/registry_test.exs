defmodule TopChefStore.RegistryTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, registry} = TopChefStore.Registry.start_link
    {:ok, registry: registry}
  end

  test "spawn buckets", %{registry: registry} do 
    assert TopChefStore.Registry.lookup(registry, "kristen_08_10")  == :error
    
    TopChefStore.Registry.create(registry, "kristen_08_10")
    assert {:ok, bucket} = TopChefStore.Registry.lookup(registry, "kristen_08_10")

    TopChefStore.Bucket.put(bucket, "kristen_08_10", 1)
    assert TopChefStore.Bucket.get(bucket, "kristen_08_10") == 1
  end

  test "removes buckets on exit", %{registry: registry} do
    TopChefStore.Registry.create(registry, "kristen_08_10")
    {:ok, bucket} = TopChefStore.Registry.lookup(registry, "kristen_08_10")
    Agent.stop(bucket)
    assert TopChefStore.Registry.lookup(registry, "kristen_08_10") == :error
  end
end
