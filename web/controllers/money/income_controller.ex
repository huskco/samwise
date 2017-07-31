defmodule Samwise.Money.IncomeController do
  use Samwise.Web, :controller
  plug :add_service_nav, "_service_nav_money.html"

  alias Samwise.Money.Income

  def index(conn, _params) do
    incomes = Repo.all(Income)
    render(conn, "index.html", incomes: incomes)
  end

  def new(conn, _params) do
    changeset = Income.changeset(%Income{})
    render(conn, "new.html", changeset: changeset)
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
    render(conn, "show.html", income: income)
  end

  def edit(conn, %{"id" => id}) do
    income = Repo.get!(Income, id)
    changeset = Income.changeset(income)
    render(conn, "edit.html", income: income, changeset: changeset)
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

  def add_service_nav(conn, template) do
    assign(conn, :service_nav, template)
  end
end
