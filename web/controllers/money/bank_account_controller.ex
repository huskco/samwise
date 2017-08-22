defmodule Samwise.Money.BankAccountController do
  use Samwise.Web, :controller
  plug Samwise.Plugs.RequireAuth
  plug :add_service_layout, "money"

  alias Samwise.Money.BankAccount

  def get_bank_account do
    Repo.get!(BankAccount, 1)
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
        render(conn, "new.html", changeset: changeset, page_title: "New account")
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
      {:ok, bank_account} ->
        conn
        |> put_flash(:info, "BankAccount updated successfully.")
        |> redirect(to: money_dashboard_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", bank_account: bank_account, changeset: changeset)
    end
  end

  def add_service_layout(conn, service) do
    Samwise.SharedController.add_service_layout(conn, service)
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
end
