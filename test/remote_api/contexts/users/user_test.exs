defmodule RemoteApi.Users.UserTest do
  use RemoteApi.DataCase, async: false

  alias RemoteApi.{
    Repo,
    Users.User
  }

  describe "database validation" do
    test "points field has constraint of values between 0 and 100 (inclusive)" do
      assert_raise Ecto.ConstraintError, fn -> Repo.insert(%User{points: -1}) end
      assert_raise Ecto.ConstraintError, fn -> Repo.insert(%User{points: 101}) end
    end
  end
end
