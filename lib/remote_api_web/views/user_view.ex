defmodule RemoteApiWeb.UserJSON do
  alias RemoteApi.Users.User

  def render("index.json", %{users: users, timestamp: timestamp}) do
    %{
      data: %{
        users: Enum.map(users, &user_json(&1)),
        timestamp: timestamp_json(timestamp)
      }
    }
  end

  defp user_json(%User{} = user) do
    %{
      id: user.id,
      points: user.points
    }
  end

  defp timestamp_json(nil), do: nil

  defp timestamp_json(timestamp) do
    timestamp
    |> NaiveDateTime.truncate(:second)
    |> NaiveDateTime.to_string()
  end
end
