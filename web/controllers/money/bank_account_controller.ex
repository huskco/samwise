defmodule Samwise.Money.BankAccountController do
  @moduledoc """
  Controller for Bank Accounts
  """
  use Samwise.Web, :controller
  plug Samwise.Plugs.RequireAuth
  plug Samwise.Plugs.AddServiceLayout, "money"

  alias Samwise.Money.BankAccount
  alias Samwise.SmartDate

  def get_bank_account do
    account = Repo.get(BankAccount, 1)
    dummy_account = %BankAccount{balance: 0.0, savings: 0.0, cushion: 0.0}
    account || dummy_account
  end

  def new(conn, _params) do
    changeset = BankAccount.changeset(%BankAccount{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"" => bank_account_params}) do
    changeset = BankAccount.changeset(%BankAccount{}, bank_account_params)

    case Repo.insert(changeset) do
      {:ok, _bank_account} ->
        conn
        |> put_flash(:info, "Account created successfully.")
        |> redirect(to: bank_account_path(conn, :index))
      {:error, changeset} ->
        render(conn,
          "new.html",
          changeset: changeset,
          page_title: "New account"
        )
    end
  end

  def edit(conn, _) do
    bank_account = get_bank_account()
    changeset = BankAccount.changeset(bank_account)
    render(conn, "edit.html", bank_account: bank_account, changeset: changeset)
  end

  def update(conn, %{"id" => _, "bank_account" => bank_account_params}) do
    bank_account = get_bank_account()
    changeset = BankAccount.changeset(bank_account, bank_account_params)

    case Repo.update(changeset) do
      {:ok, _bank_account} ->
        conn
        |> put_flash(:info, "BankAccount updated successfully.")
        |> redirect(to: money_dashboard_path(conn, :index))
      {:error, changeset} ->
        render(conn,
          "edit.html",
          bank_account: bank_account,
          changeset: changeset
        )
    end
  end

  def balance do
    account = get_bank_account()
    account.balance
  end

  def savings do
    account = get_bank_account()
    account.savings
  end

  def cushion do
    account = get_bank_account()
    account.cushion
  end

  def updated_at do
    account = get_bank_account()
    account.updated_at
      |> SmartDate.pretty_date(:day)
  end
end
