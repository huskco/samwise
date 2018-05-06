defmodule Samwise.Money.BankAccountController do
  @moduledoc """
  Controller for Bank Accounts
  """
  use Samwise.Web, :controller
  plug Samwise.Plugs.RequireAuth
  plug Samwise.Plugs.AddServiceLayout, "money"

  alias Samwise.Money.BankAccount

  def index(conn, _params) do
    render(conn,
      "index.html",
      bank_accounts: all_bank_accounts(),
      total_available: total_available(),
      page_title: "Bank Accounts"
    )
  end

  def new(conn, _params) do
    changeset = BankAccount.changeset(%BankAccount{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"bank_account" => bank_account_params}) do
    changeset = BankAccount.changeset(%BankAccount{}, bank_account_params)

    case Repo.insert(changeset) do
      {:ok, _bank_account} ->
        conn
        |> put_flash(:info, "Bank Account created successfully.")
        |> redirect(to: bank_account_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, page_title: "New Bank Account")
    end
  end

  def edit(conn, %{"id" => id}) do
    bank_account = Repo.get!(BankAccount, id)
    changeset = BankAccount.changeset(bank_account)
    render(conn,
      "edit.html",
      bank_account: bank_account,
      changeset: changeset,
      page_title: "Edit #{bank_account.name}"
    )
  end

  def update(conn, %{"id" => id, "bank_account" => bank_account_params}) do
    bank_account = Repo.get!(BankAccount, id)
    changeset = BankAccount.changeset(bank_account, bank_account_params)

    case Repo.update(changeset) do
      {:ok, _bank_account} ->
        conn
        |> put_flash(:info, "Bank Account updated successfully.")
        |> redirect(to: bank_account_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", bank_account: bank_account, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    bank_account = Repo.get!(BankAccount, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(bank_account)

    conn
    |> put_flash(:info, "Bank Account deleted successfully.")
    |> redirect(to: bank_account_path(conn, :index))
  end

  def all_bank_accounts do
    BankAccount
      |> order_by(asc: :name)
      |> Repo.all
  end

  def total do
    Repo.one(from ba in BankAccount, select: sum(ba.amount))
  end

  def total_available do
    Repo.one(
      from ba in BankAccount,
      where: ba.is_available == true,
      select: sum(ba.amount)
    )
  end

  def total_investments do
    Repo.one(
      from ba in BankAccount,
      where: ba.is_investment == true,
      select: sum(ba.amount)
    )
  end
end
