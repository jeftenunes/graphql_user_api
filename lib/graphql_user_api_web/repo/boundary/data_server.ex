defmodule GraphqlUserApiWeb.Repo.Boundary.DataServer do
  use GenServer

  def start_link(initial_state),
    do: GenServer.start_link(__MODULE__, Enum.into(initial_state, %{}), name: __MODULE__)

  def init(_state), do: {:ok, %{}}

  def handle_call(
        {:put, %{id: id, name: name, email: email, preferences: preferences}},
        _from,
        state
      ) do
    state = Map.put(state, id, %{id: id, name: name, email: email, preferences: preferences})
    {:reply, state[id], state}
  end

  def handle_call({:get, id}, _from, state),
    do: {:reply, state[id], state}

  def handle_call({:get_all}, _from, state),
    do: {:reply, Map.values(state), state}

  def put(%{id: _id, name: _name, email: _email} = data) do
    GenServer.call(__MODULE__, {:put, data})
  end

  def get_by(id) do
    GenServer.call(__MODULE__, {:get, id})
  end

  def get_all(), do: GenServer.call(__MODULE__, {:get_all})
end
