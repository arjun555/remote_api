defmodule RemoteApi.Users do
  import Ecto.Query

  alias RemoteApi.{
    Repo,
    Users.User
  }

  @doc """
    Query all users with more points than `min_points`, with number of
    results limited by `limit`
  """
  def list_by_points(min_points, limit) do
    User
    |> where([u], u.points >= ^min_points)
    |> limit(^limit)
    |> Repo.all()
  end

  def update_points_for_all_users(min_points, max_points) do
    {entries, _results} =
      User
      |> update(
        set: [
          points:
            fragment(
              "floor(random() * (? - ? + 1) + ?)",
              type(^max_points, :integer),
              type(^min_points, :integer),
              type(^min_points, :integer)
            )
        ]
      )
      |> Repo.update_all([])

    {:ok, entries}
  end
end
