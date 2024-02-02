defmodule PhoenixRestWeb.Router do
    use PhoenixRestWeb, :router

    pipeline :api do
        plug :accepts, ["json"]
    end

    scope "/api", PhoenixRestWeb do
        pipe_through :api

        get "/", DefaultController, :index
    end
end
