defmodule Samwise.Money.BillController do
  @moduledoc """
    Controller for Money Bill
  """
  use Samwise.Web, :controller
  plug Samwise.Plugs.RequireAuth
  plug Samwise.Plugs.AddServiceLayout, "money"

  alias Samwise.Money.Bill

  def index(conn, _params) do
    render(conn,
      "index.html",
      bills: all_bills(),
      total: total(),
      page_title: "Bills"
    )
  end

  def new(conn, _params) do
    changeset = Bill.changeset(%Bill{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"bill" => bill_params}) do
    changeset = Bill.changeset(%Bill{}, bill_params)

    case Repo.insert(changeset) do
      {:ok, _bill} ->
        conn
        |> put_flash(:info, "Bill created successfully.")
        |> redirect(to: bill_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, page_title: "New bill")
    end
  end

  def edit(conn, %{"id" => id}) do
    bill = Repo.get!(Bill, id)
    changeset = Bill.changeset(bill)
    render(conn,
      "edit.html",
      bill: bill,
      changeset: changeset,
      page_title: "Edit #{bill.name}"
    )
  end

  def update(conn, %{"id" => id, "bill" => bill_params}) do
    bill = Repo.get!(Bill, id)
    changeset = Bill.changeset(bill, bill_params)

    case Repo.update(changeset) do
      {:ok, _bill} ->
        conn
        |> put_flash(:info, "Bill updated successfully.")
        |> redirect(to: bill_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", bill: bill, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    bill = Repo.get!(Bill, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(bill)

    conn
    |> put_flash(:info, "Bill deleted successfully.")
    |> redirect(to: bill_path(conn, :index))
  end

  def all_bills do
    Bill
      |> order_by(asc: :name)
      |> Repo.all
  end

  def total do
    Repo.one(from b in Bill, select: sum(b.amount))
  end

  def debt_total do
    Repo.one(
      from b in Bill,
      where: b.is_debt == true,
      select: sum(b.amount)
    )
  end
end
