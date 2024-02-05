defmodule PhoenixRestWeb.Router do
    use PhoenixRestWeb, :router
    use Plug.ErrorHandler

    defp handle_errors(conn, %{reason: %Phoenix.Router.NoRouteError{message: message}}) do
        conn |> json(%{status: "fail", errors: message}) |> halt()
    end

    defp handle_errors(conn, %{reason: %{message: message}}) do
        conn |> json(%{status: "fail", errors: message}) |> halt()
    end

    pipeline :api do
        plug :accepts, ["json"]
        plug :fetch_session
    end

    pipeline :auth do
        plug PhoenixRestWeb.Auth.Pipeline
        plug PhoenixRestWeb.Auth.SetAccount
    end

    scope "/api", PhoenixRestWeb do
        pipe_through :api

        get "/", DefaultController, :index
        post "/accounts", AccountController, :create
        post "/accounts/sign-in", AccountController, :sign_in
    end

    scope "/api", PhoenixRestWeb do
        pipe_through [:api, :auth]

        get "/accounts/:id", AccountController, :show
        post "/accounts/:id/update", AccountController, :update
    end
end
