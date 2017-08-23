defmodule Samwise.User do
  @moduledoc """
  User Model for Samwise based on Ueberauth
  """
  use Samwise.Web, :model

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :provider, :string
    field :token, :string

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:first_name, :last_name, :email, :provider, :token])
    |> validate_required([:first_name, :last_name, :email, :provider, :token])
    |> validate_whitelisted_user
  end

  def validate_whitelisted_user(changeset) do
    email = changeset
      |> get_field(:email)
    validate_whitelisted_user(changeset, email)
  end

  def validate_whitelisted_user(changeset, email) do
    whitelisted_users = "WHITELISTED_USERS"
      |> System.get_env()
      |> String.split(", ")
    if Enum.member?(whitelisted_users, email) do
      changeset
    else
      changeset
        |> add_error(:email, "User is not whitelisted")
    end
  end
end
