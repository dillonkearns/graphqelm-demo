defmodule StarWarsWeb.PageController do
  use StarWarsWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
