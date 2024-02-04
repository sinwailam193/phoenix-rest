defmodule PhoenixRestWeb.Auth.Pipeline do
    use Guardian.Plug.Pipeline, otp_app: :phoenix_rest,
    module: PhoenixRestWeb.Auth.Guardian,
    error_handler: PhoenixRestWeb.Auth.GuardianErrorHandler

    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.EnsureAuthenticated
    plug Guardian.Plug.LoadResource
end
