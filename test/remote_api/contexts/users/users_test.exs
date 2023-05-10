defmodule RemoteApi.UsersTest do
  use RemoteApi.DataCase, async: false

  alias RemoteApi.{
    Repo,
    Users,
    Users.User
  }

  describe "list_by_points/2" do
    test "returns list of users, given min_number" do
      min_points = 1

      {:ok, %User{} = user} = insert_user_with_points(10)

      assert [^user] = Users.list_by_points(min_points, 1)
    end

    test "returns limited number of users, given limit " do
      insert_user_with_points(10)
      insert_user_with_points(10)
      limit = 1

      assert [%User{}] = Users.list_by_points(10, limit)
    end

    test "returns empty list, when no records found" do
      assert [] = Users.list_by_points(10, 1)
    end
  end

  describe "update_points_for_all_users/2" do
    test "updates all users" do
      {:ok, %{id: user_id}} = insert_user_with_points(10)
      min_points = 0
      max_points = 0

      assert {:ok, _} = Users.update_points_for_all_users(min_points, max_points)
      assert [%User{id: ^user_id, points: 0}] = Repo.all(User)
    end

    test "updates users with random points between given bounds" do
      {:ok, %{id: user_id}} = insert_user_with_points(10)
      min_points = 0
      max_points = 1

      for _ <- 0..99 do
        assert {:ok, _} = Users.update_points_for_all_users(min_points, max_points)

        [%User{id: ^user_id} = updated_user] = Repo.all(User)
        assert updated_user.points >= min_points && updated_user.points <= max_points
      end
    end
  end

  defp insert_user_with_points(points) do
    Repo.insert(%User{points: points})
  end
end
