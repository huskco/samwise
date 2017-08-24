defmodule Samwise.Money.BudgetController do
  @moduledoc """
    Controller for Money Budget
  """
  use Samwise.Web, :controller
  plug Samwise.Plugs.RequireAuth
  plug Samwise.Plugs.AddServiceLayout, "money"

  alias Samwise.Money.Budget

  def index(conn, _params) do
    render(conn,
      "index.html",
      budgets: all_budgets(),
      total: total(),
      daily_average: daily_average(),
      page_title: "Budgets"
    )
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

  def edit(conn, %{"id" => id}) do
    budget = Repo.get!(Budget, id)
    changeset = Budget.changeset(budget)
    render(conn,
      "edit.html",
      budget: budget,
      changeset: changeset,
      page_title: "Edit #{budget.name}"
    )
  end

  def update(conn, %{"id" => id, "budget" => budget_params}) do
    budget = Repo.get!(Budget, id)
    changeset = Budget.changeset(budget, budget_params)

    case Repo.update(changeset) do
      {:ok, _budget} ->
        conn
        |> put_flash(:info, "Budget updated successfully.")
        |> redirect(to: budget_path(conn, :index))
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
    Budget
      |> order_by(asc: :name)
      |> Repo.all
  end

  def total do
    Repo.one(from b in Budget, select: sum(b.amount))
  end

  def daily_average do
    case is_float(total()) do
      true -> total() / 30
      false -> 0
    end
  end
end
