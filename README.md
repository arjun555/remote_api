# RemoteApi

To start the phoenix application:
- Run `mix deps.get` to install and setup dependencies
- Run `mix ecto.setup` to run migrations and seed database
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

To run the tests:
- `mix test`

# Decisions
- To perform the bulk points update of the Users, decision was made to utilise `Repo.update_all` rather than `Repo.update`
  - `Repo.update` would require read/ modify/ update which is a longer process compared to `Repo.update_all` which will execute in one query
  - The trade off between the two is performance vs validation. It would be nice to run the inserts through a changeset to ensure data is valid before hitting the database.
    - However by adding the database constraint for `user.points`, there is still validation and therefore minimizing the chance of malformed data
- GenServer Tests
  - No unit test callback functions. They are never called in a pure sense, but called by the GenServer itself. So it is best to call the Genserver as it is used, to get the full implementation
  - Had to remove the inclusion of `RemoteApi.PointsUpdater` during tests from the applications Supervisor, as it was conflicting with `start_supervised!(children)` in tests
- Seeding 1,000,000 users required batching due to due to Postgres parameter limit of 65_535.
  - As Users has 3 parameters: 65_000/3 = ~21_666 maximum records per transaction,
  - 50 transactions of 20_000 inserts are performed
- The GenServer task of updating all user points is handled asynchronously.
  - This allows the application to process other requests, in this case retrieving users while also updating
  - Added the Task to the GenServer state, as a mechanism to prevent multiple instances of the same Task spawning.

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
