defmodule TopChefStore.BucketTest do
  use ExUnit.Case, async: true
  alias TopChefStore.Bucket

  setup do
    {:ok, bucket} = Bucket.start_link
    {:ok, bucket: bucket}
  end

  test "stores value by key", %{bucket: bucket} do
    assert Bucket.get(bucket, "kristen_8_10") == nil

    dish_data = %{ 
      "name" => "Oysters with Caramelized Honey Tomato Broth, Celery Leaves and Chili",
      "contestant" => "Kristen",
      "episode" => 8,
      "season" => 10,
      "is_winning" => "false",	
      "is_losing" => "false",
      "is_team" => "false",
      "challenge_type" => "quickfire",
    }

    Bucket.put(bucket, "kristen_8_10", dish_data) 
    assert Bucket.get(bucket, "kristen_8_10") == dish_data
  end

  test "deletes key from bucket", %{bucket: bucket} do
    Bucket.put(bucket, "foo", "bar")  
    assert Bucket.delete(bucket, "foo") == "bar"
    assert Bucket.get(bucket, "foo") == nil
  end
end
