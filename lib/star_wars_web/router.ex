defmodule StarWarsWeb.Router do
  use StarWarsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :api

    forward "/api", Absinthe.Plug,
      schema: StarWarsWeb.Schema

    forward "/", Absinthe.Plug.GraphiQL,
      schema: StarWarsWeb.Schema,
      interface: :simple,
      socket: StarWarsWeb.UserSocket
  end

end
