defmodule RemoteApi.Repo do
  use Ecto.Repo,
    otp_app: :remote_api,
    adapter: Ecto.Adapters.Postgres
end
