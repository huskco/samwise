defmodule Samwise.Money.BudgetController do
  use Samwise.Web, :controller
  plug :add_service_layout, "money"

  alias Samwise.Money.Budget

  def index(conn, _params) do
    render(conn, "index.html", budgets: all_budgets(), total: total(), page_title: "Budgets")
  end

  def new(conn, _params) do
    changeset = Budget.changeset(%Budget{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"budget" => budget_params}) do
    changeset = Budget.changeset(%Budget{}, budget_params)

    case Repo.insert(changeset) do
      {:ok, _budget} ->
        conn
        |> put_flash(:info, "Budget created successfully.")
        |> redirect(to: budget_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, page_title: "New Bill")
    end
  end

  def show(conn, %{"id" => id}) do
    budget = Repo.get!(Budget, id)
    render(conn, "show.html", budget: budget, page_title: budget.name)
  end

  def edit(conn, %{"id" => id}) do
    budget = Repo.get!(Budget, id)
    changeset = Budget.changeset(budget)
    render(conn, "edit.html", budget: budget, changeset: changeset, page_title: "Edit #{budget.name}")
  end

  def update(conn, %{"id" => id, "budget" => budget_params}) do
    budget = Repo.get!(Budget, id)
    changeset = Budget.changeset(budget, budget_params)

    case Repo.update(changeset) do
      {:ok, budget} ->
        conn
        |> put_flash(:info, "Budget updated successfully.")
        |> redirect(to: budget_path(conn, :show, budget))
      {:error, changeset} ->
        render(conn, "edit.html", budget: budget, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    budget = Repo.get!(Budget, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(budget)

    conn
    |> put_flash(:info, "Budget deleted successfully.")
    |> redirect(to: budget_path(conn, :index))
  end

  def all_budgets do
    from(budget in Budget, order_by: budget.name) |> Repo.all
  end

  def add_service_layout(conn, service) do
    Samwise.SharedController.add_service_layout(conn, service)
  end

  def total do
    Repo.one(from b in Budget, select: sum(b.amount))
  end
end
