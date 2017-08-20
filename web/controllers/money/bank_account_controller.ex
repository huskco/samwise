defmodule Samwise.Money.BankAccountController do
  use Samwise.Web, :controller
  plug Samwise.Plugs.RequireAuth

  alias Samwise.Money.BankAccount

  def get_bank_account do
    Repo.get!(BankAccount, 1)
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
        |> redirect(to: bank_account_path(conn, :show, bank_account))
      {:error, changeset} ->
        render(conn, "edit.html", bank_account: bank_account, changeset: changeset)
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

  def available do
    account = get_bank_account()
    account.balance + account.savings - account.cushion
  end
end
