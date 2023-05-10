defmodule RemoteApiWeb.Router do
  use RemoteApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RemoteApiWeb do
    pipe_through :api

    get "/", UserController, :index
  end
end
