defmodule PhoenixRestWeb.Auth.SetAccount do
    import Plug.Conn
    alias PhoenixRestWeb.Auth.ErrorResponse
    alias PhoenixRest.Accounts

    def init(_options) do end

    def call(conn, _options) do
        if conn.assigns[:account] do
            conn
        else
            case get_session(conn, :account_id) do
                nil -> raise ErrorResponse.Unauthorized
                account_id ->
                    case Accounts.get_account!(account_id) do
                        nil -> assign(conn, :account, nil)
                        account -> assign(conn, :account, account)
                    end
            end
        end
    end
end
