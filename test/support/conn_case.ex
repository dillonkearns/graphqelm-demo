defmodule StarWarsWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common datastructures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      import StarWarsWeb.Router.Helpers

      # The default endpoint for testing
      @endpoint StarWarsWeb.Endpoint
    end
  end

  def auth_user(conn, user) do
    # hack so that xref errors don't happen on branches without this module
    token = apply(StarWarsWeb.Authentication, :sign, [%{role: user.role, id: user.id}])
    conn
    |> Plug.Conn.put_req_header("Authorization", "Bearer #{token}")
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(StarWars.Repo)
    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(StarWars.Repo, {:shared, self()})
    end
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

end
