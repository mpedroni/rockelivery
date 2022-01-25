defmodule Rockelivery.Stack do
  use GenServer

  alias __MODULE__, as: Stack

  # client

  def start_link(initial_stack) when is_list(initial_stack) do
    GenServer.start_link(Stack, initial_stack)
  end

  def push(pid, element) do
    GenServer.cast(pid, {:push, element})
  end

  def pop(pid) do
    GenServer.call(pid, :pop)
  end

  # server (callbacks)

  @impl true
  def init(stack) do
    {:ok, stack}
  end

  @impl true
  # sync
  def handle_call({:push, element}, _from, stack) do
    new_stack = [element | stack]
    {:reply, new_stack, new_stack}
  end

  @impl true
  def handle_call(:pop, _from, [head | tail]), do: {:reply, head, tail}

  @impl true
  def handle_call(:pop, _from, []), do: {:reply, nil, []}

  @impl true
  # async
  def handle_cast({:push, element}, stack) do
    {:noreply, [element | stack]}
  end
end
