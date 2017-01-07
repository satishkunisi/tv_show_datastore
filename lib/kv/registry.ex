defmodule TopChefStore.Registry do
  use GenServer

 @doc """
  Starts the registry.
  """
  def start_link do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  @doc """
  Looks up the bucket pid for `name` stored in `server`

  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise'
  """
  def lookup(server, name) do
    GenServer.call(server, {:lookup, name})
  end

  @doc """
  Ensures there is a bucket associated to the given `name` in `server`
  """
  def create(server, name) do  
    GenServer.call(server, {:create, name})
  end

  ## Server Callbacks

  def init(:ok) do
    {:ok, %{}}
  end
  
  def handle_call({:lookup, name}, _from, names) do
    {:reply, Map.fetch(names, name), names}
  end

  def handle_call({:create, name}, _from, names) do
    if Map.has_key?(names, name) do
      {:reply, Map.fetch(names, name), names}
    else
      {:ok, bucket} = TopChefStore.Bucket.start_link
      new_names = Map.put(names, name, bucket)
      {:reply, Map.fetch(new_names, name), new_names}
    end
  end
end
