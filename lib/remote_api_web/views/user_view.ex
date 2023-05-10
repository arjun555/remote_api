defmodule RemoteApiWeb.UserJSON do

  def render("index.json", %{users: users, timestamp: timestamp}) do
    %{
      data: %{
        users: Enum.map(users, &Map.take(&1, [:id, :points])),
        timestamp: timestamp_json(timestamp)
      }
    }
  end

  defp timestamp_json(nil), do: nil

  defp timestamp_json(timestamp) do
    timestamp
    |> NaiveDateTime.truncate(:second)
    |> NaiveDateTime.to_string()
  end
end
