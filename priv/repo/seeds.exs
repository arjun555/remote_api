# Bulk insert %User{} to generate 1_0000_000 user seeds, each with 0 points.
#
# Required to batch database inserts, due to Postgres parameter limit of 65_535.
# As Users has 3 parameters: 65_000/3 = ~21_666 maximum records per transaction,
# 50 transactions of 20_000 inserts are performed

for _ <- 0..49 do
  dt_now = NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
  users = Enum.map(0..19_999, fn _ -> %{points: 0, inserted_at: dt_now, updated_at: dt_now} end)
  RemoteApi.Repo.insert_all(RemoteApi.Users.User, users)
end
