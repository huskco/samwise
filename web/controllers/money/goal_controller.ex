defmodule Samwise.Money.GoalController do
  use Samwise.Web, :controller
  plug :add_service_nav, "_service_nav_money.html"

  alias Samwise.Money.Goal

  def index(conn, _params) do
    goals = Repo.all(Goal)
    render(conn, "index.html", goals: goals, total: total(), page_title: "Goals")
  end

  def new(conn, _params) do
    changeset = Goal.changeset(%Goal{})
    render(conn, "new.html", changeset: changeset, page_title: "New Goal")
  end

  def create(conn, %{"goal" => goal_params}) do
    changeset = Goal.changeset(%Goal{}, goal_params)

    case Repo.insert(changeset) do
      {:ok, _goal} ->
        conn
        |> put_flash(:info, "Goal created successfully.")
        |> redirect(to: goal_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    goal = Repo.get!(Goal, id)
    render(conn, "show.html", goal: goal, page_title: goal.name)
  end

  def edit(conn, %{"id" => id}) do
    goal = Repo.get!(Goal, id)
    changeset = Goal.changeset(goal)
    render(conn, "edit.html", goal: goal, changeset: changeset, page_title: "Edit #{goal.name}")
  end

  def update(conn, %{"id" => id, "goal" => goal_params}) do
    goal = Repo.get!(Goal, id)
    changeset = Goal.changeset(goal, goal_params)

    case Repo.update(changeset) do
      {:ok, goal} ->
        conn
        |> put_flash(:info, "Goal updated successfully.")
        |> redirect(to: goal_path(conn, :show, goal))
      {:error, changeset} ->
        render(conn, "edit.html", goal: goal, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    goal = Repo.get!(Goal, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(goal)

    conn
    |> put_flash(:info, "Goal deleted successfully.")
    |> redirect(to: goal_path(conn, :index))
  end

  def add_service_nav(conn, template) do
    assign(conn, :service_nav, template)
  end

  def total do
    Repo.one(from g in Goal, select: sum(g.amount))
  end
end
