defmodule PhoenixRestWeb.AccountJSON do
    alias PhoenixRest.Accounts.Account

    @doc """
    Renders a list of accounts.
    """
    def index(%{accounts: accounts}) do
        for(account <- accounts, do: data(account))
    end

    @doc """
    Renders a single account.
    """
    def show(%{account: account}) do
        data(account)
    end

    defp data(%Account{} = account) do
        %{
            id: account.id,
            email: account.email
        }
    end

    def account_token(%{account: account, token: token}) do
        %{
            id: account.id,
            email: account.email,
            token: token
        }
    end
end
