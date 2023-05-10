defmodule RemoteApiWeb.UserController do
  use RemoteApiWeb, :controller

  alias RemoteApi.PointsUpdater

  def index(conn, _params) do
    data = PointsUpdater.get_users()
    render(conn, "index.json", data)
  end
end
