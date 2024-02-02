defmodule PhoenixRestWeb.DefaultController do
    use PhoenixRestWeb, :controller

    def index(conn, _params) do
        text conn, "testing endpoint #{Mix.env()}"
    end
end
