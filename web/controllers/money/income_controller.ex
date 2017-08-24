defmodule Samwise.Money.IncomeController do
  use Samwise.Web, :controller
  plug Samwise.Plugs.RequireAuth
  plug Samwise.Plugs.AddServiceLayout, "money"

  alias Samwise.Money.Income

  def index(conn, _params) do
    render(conn, "index.html", incomes: all_incomes(), total: total(), page_title: "Incomes")
  end

  def new(conn, _params) do
    changeset = Income.changeset(%Income{})
    render(conn, "new.html", changeset: changeset, page_title: "New Income")
  end

  def create(conn, %{"income" => income_params}) do
    changeset = Income.changeset(%Income{}, income_params)

    case Repo.insert(changeset) do
      {:ok, _income} ->
        conn
        |> put_flash(:info, "Income created successfully.")
        |> redirect(to: income_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    income = Repo.get!(Income, id)
    render(conn, "show.html", income: income, page_title: income.name)
  end

  def edit(conn, %{"id" => id}) do
    income = Repo.get!(Income, id)
    changeset = Income.changeset(income)
    render(conn, "edit.html", income: income, changeset: changeset, page_title: "Edit #{income.name}")
  end

  def update(conn, %{"id" => id, "income" => income_params}) do
    income = Repo.get!(Income, id)
    changeset = Income.changeset(income, income_params)

    case Repo.update(changeset) do
      {:ok, income} ->
        conn
        |> put_flash(:info, "Income updated successfully.")
        |> redirect(to: income_path(conn, :show, income))
      {:error, changeset} ->
        render(conn, "edit.html", income: income, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    income = Repo.get!(Income, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(income)

    conn
    |> put_flash(:info, "Income deleted successfully.")
    |> redirect(to: income_path(conn, :index))
  end

  def all_incomes do
    Income
      |> order_by(asc: :name)
      |> Repo.all
  end

  def total do
    Repo.one(from i in Income, select: sum(i.amount))
  end
end
