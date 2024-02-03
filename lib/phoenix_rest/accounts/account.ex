defmodule PhoenixRest.Accounts.Account do
    use Ecto.Schema
    import Ecto.Changeset

    @primary_key {:id, :binary_id, autogenerate: true}
    @foreign_key_type :binary_id
    schema "accounts" do
        field :email, :string
        field :hash_password, :string
        has_one :user, PhoenixRest.Users.User

        timestamps(type: :utc_datetime)
    end

    @doc false
    def changeset(account, attrs) do
        account
        |> cast(attrs, [:email, :hash_password])
        |> validate_required([:email, :hash_password])
        |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "Must be a valid email and no spaces.")
        |> validate_length(:email, max: 160)
        |> unique_constraint(:email)
    end
end