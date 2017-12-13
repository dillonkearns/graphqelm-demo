defmodule StarWarsWeb.Schema.Query.HumanTest do
  use StarWarsWeb.ConnCase, async: true

  @query """
  {
    human(id: 1004) {
      name
      id
      friends {
        name
      }
    }
  }
  """
  test "human with friends" do
    conn = build_conn()
    conn = get conn, "/api", query: @query
    assert json_response(conn, 200) ==
      %{"data" => %{"human" =>
        %{"friends" =>
          [%{"name" => "Darth Vader"}],
         "id" => "1004", "name" => "Wilhuff Tarkin"}
       }
    }
  end

  @query """
  {
    droid(id: 2001) {
      name
      id
      friends {
        name
      }
    }
  }
  """
  test "droid with friends" do
    conn = build_conn()
    conn = get conn, "/api", query: @query
    assert json_response(conn, 200) ==
      %{"data" =>
        %{"droid" =>
          %{"friends" =>
            [%{"name" => "Luke Skywalker"},
             %{"name" => "Han Solo"},
              %{"name" => "Leia Organa"}],
             "id" => "2001",
              "name" => "R2-D2"}
              }
      }
  end

  @query """
  {
    hero {
      name
    }
  }
  """
  test "hero endpoint with no args" do
    conn = build_conn()
    conn = get conn, "/api", query: @query
    assert json_response(conn, 200) ==
      %{"data" => %{"hero" => %{"name" => "Luke Skywalker"}}}
  end

  @query """
  {
    hero(episode: NEWHOPE) {
      name
    }
  }
  """
  test "hero endpoint with arg" do
    conn = build_conn()
    conn = get conn, "/api", query: @query
    assert json_response(conn, 200) ==
      %{"data" => %{"hero" => %{"name" => "R2-D2"}}}
  end
end
