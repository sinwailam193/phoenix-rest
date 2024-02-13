defmodule PhoenixRestWeb.AccountController do
    use PhoenixRestWeb, :controller

    alias PhoenixRestWeb.Auth.{Guardian, ErrorResponse}
    alias PhoenixRest.{Repo, Accounts, Accounts.Account, Users}

    # run this plug only when it is hitting update or delete action
    plug :is_authorized_account when action in [:update, :delete, :sign_out, :refresh_session]

    action_fallback PhoenixRestWeb.FallbackController

    defp is_authorized_account(conn, _opts) do
        %{account: account} = conn.assigns
        if account.id === conn.params["id"] do
            conn
        else
            raise ErrorResponse.Forbidden
        end
    end

    def index(conn, _params) do
        accounts = Accounts.list_accounts()
        render(conn, :index, accounts: accounts)
    end

    def create(conn, %{"account" => account_params}) do
        case Repo.transaction(fn ->
            account = Accounts.create_account!(account_params)
            Users.create_user!(account, account_params)
            account
        end) do
            {:ok, account} -> authorize_account(conn, account.email, account_params["hash_password"])
            {:error, _} -> raise ErrorResponse.InternalServerError
        end
    end

    def sign_in(conn, %{"email" => email, "password" => hash_password}) do
        authorize_account(conn, email, hash_password)
    end

    defp authorize_account(conn, email, hash_password) do
        case Guardian.authenticate(email, hash_password) do
            {:ok, account, token} ->
                conn
                |> Plug.Conn.put_session(:account_id, account.id)
                |> put_status(:ok)
                |> render(:account_token, account: account, token: token)
            {:error, :unauthorized} -> raise ErrorResponse.Unauthorized, message: "Email or password incorrect."
        end
    end

    def refresh_session(conn, %{}) do
        token = conn |> Guardian.Plug.current_token()
        {:ok, account, new_token} = Guardian.authenticate(token)
        conn
        |> Plug.Conn.put_session(:account_id, account.id)
        |> put_status(:ok)
        |> render(:account_token, account: account, token: new_token)
    end

    def sign_out(conn, %{}) do
        account = conn.assigns[:account]
        token = Guardian.Plug.current_token(conn)

        Guardian.revoke(token)

        conn
        |> Plug.Conn.clear_session()
        |> put_status(:ok)
        |> render(:account_token, account: account, token: nil)
    end

    def show(conn, %{"id" => _id}) do
        render(conn, :show, account: conn.assigns[:account])
    end

    def update(conn, %{"account" => account_params}) do
        %{account: account} = conn.assigns

        with {:ok, %Account{} = account} <- Accounts.update_account(account, account_params) do
            render(conn, :show, account: account)
        end
    end

    def delete(conn, %{"id" => id}) do
        account = Accounts.get_account!(id)

        with {:ok, %Account{}} <- Accounts.delete_account(account) do
            send_resp(conn, :no_content, "")
        end
    end
end
