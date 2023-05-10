defmodule RemoteApi.PointsUpdaterTest do
  use RemoteApi.DataCase, async: false

  alias RemoteApi.{
    PointsUpdater,
    Users.User
  }

  describe "get_users/0" do
    test "returns response with users, limited to 2 records" do
      _pid = start_supervised!({PointsUpdater, [min_number: 0]})
      {:ok, _user} = insert_user_with_points(0)
      {:ok, _user} = insert_user_with_points(100)

      assert %{users: [%User{}, %User{}]} = PointsUpdater.get_users()
    end

    test "returns updated timestamp each call" do
      _pid = start_supervised!(PointsUpdater)

      assert %{timestamp: nil} = PointsUpdater.get_users()

      %{timestamp: %NaiveDateTime{} = timestamp_1} = PointsUpdater.get_users()
      assert timestamp_1 <= NaiveDateTime.utc_now()
    end
  end

  defp insert_user_with_points(points) do
    Repo.insert(%User{points: points})
  end
end
