defmodule RemoteApiWeb.UserControllerTest do
  use RemoteApiWeb.ConnCase, async: false

  alias RemoteApi.{
    PointsUpdater,
    Repo,
    Users.User
  }

  describe "index/2" do
    setup do
      _pid = start_supervised!({PointsUpdater, [min_number: 0]})

      :ok
    end

    test "returns 200 with data", %{conn: conn} do
      {:ok, _user_1} = Repo.insert(%User{points: 10})
      {:ok, _user_2} = Repo.insert(%User{points: 100})

      conn = get(conn, "/")

      assert %{
               "users" => [%{"id" => _, "points" => 10}, %{"id" => _, "points" => 100}],
               "timestamp" => nil
             } = json_response(conn, 200)["data"]
    end

    test "returns timestamp as nil on first query and as a value on subsequent queries", %{
      conn: conn
    } do
      conn = get(conn, "/")

      assert %{
               "users" => _,
               "timestamp" => nil
             } = json_response(conn, 200)["data"]

      conn = get(conn, "/")

      assert %{
               "users" => _,
               "timestamp" => timestamp
             } = json_response(conn, 200)["data"]

      assert is_binary(timestamp)
    end
  end
end
