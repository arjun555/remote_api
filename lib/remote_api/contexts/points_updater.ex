defmodule RemoteApi.PointsUpdater do
  use GenServer

  alias RemoteApi.Users

  @mod __MODULE__
  @min_points 0
  @max_points 100
  @max_user_records 2
  @update_frequency_ms 2_000

  @moduledoc """
    Some module docs
  """

  def start_link(opts \\ []) do
    GenServer.start_link(@mod, opts, name: @mod)
  end

  @impl true
  def init(opts) do
    schedule_work()
    min_number = Keyword.get(opts, :min_number, random_number_generator(@min_points, @max_points))

    {:ok, %{min_number: min_number, timestamp: nil}}
  end

  def get_users() do
    GenServer.call(@mod, :get_users)
  end

  @impl true
  def handle_call(:get_users, _from, %{min_number: min_number, timestamp: timestamp} = state) do
    task = Task.async(fn -> Users.list_by_points(min_number, @max_user_records) end)
    users = Task.await(task)
    resp = %{users: users, timestamp: timestamp}
    dt_now = NaiveDateTime.utc_now()
    updated_state = Map.put(state, :timestamp, dt_now)

    {:reply, resp, updated_state}
  end

  # Task is already in progress, so do not start another
  @impl true
  def handle_info(:update_user_points, %{task_in_progress: %Task{}} = state) do
    schedule_work()

    {:noreply, state}
  end

  # Creates task to bulk update Users table
  @impl true
  def handle_info(:update_user_points, state) do
    task = Task.async(fn -> Users.update_points_for_all_users(@min_points, @max_points) end)

    min_number = random_number_generator(@min_points, @max_points)

    updated_state =
      state
      |> Map.put(:min_number, min_number)
      |> Map.put(:task_in_progress, task)

    schedule_work()
    {:noreply, updated_state}
  end

  # When Task ends, the Process monitor will deliver the :DOWN message
  @impl true
  def handle_info(
        {:DOWN, ref, :process, _object, _reason},
        %{task_in_progress: %Task{ref: ref}} = state
      ) do
    updated_state =
      state
      |> Map.put(:task_in_progress, nil)

    {:noreply, updated_state}
  end

  @impl true
  def handle_info(_message, state) do
    {:noreply, state}
  end

  defp random_number_generator(min, max) do
    :rand.uniform(max - min + 1) + min - 1
  end

  defp schedule_work() do
    Process.send_after(self(), :update_user_points, @update_frequency_ms)
  end
end
