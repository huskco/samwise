defmodule Samwise.Money.GoalController do
  use Samwise.Web, :controller
  plug Samwise.Plugs.RequireAuth
  plug :add_service_layout, "money"

  alias Samwise.Money.Goal

  def index(conn, _params) do
    goals = all_goals()
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

  def all_goals do
    from(goal in Goal, order_by: goal.order) |> Repo.all |> add_progress
  end

  def add_service_layout(conn, service) do
    Samwise.SharedController.add_service_layout(conn, service)
  end

  def total do
    Repo.one(from g in Goal, select: sum(g.amount))
  end

  def add_progress(goals) do
    available_to_spend = Samwise.Money.ForecastController.get_available_to_spend()
    add_progress(goals, available_to_spend, [])
  end

  def add_progress([head | tail], available_to_spend, acc) do
    progress = case head.amount < available_to_spend do
      true -> head.amount
      false -> available_to_spend
    end
    updated_item = head
      |> Map.put(:progress, progress)
      |> Map.put(:progress_percentage, round(progress / head.amount * 100))
    updated_acc = acc ++ [updated_item]
    updated_available_to_spend = available_to_spend - progress
    add_progress(tail, updated_available_to_spend, updated_acc)
  end

  def add_progress([], _available_to_spend, acc) do
    acc
  end

  def estimated_goal_month(goal) do
    to_go = goal.amount - goal.progress
    surplus = Samwise.Money.MoneyDashboardController.surplus()
    months = round(to_go / surplus)

    {:ok, pretty_date} = Timex.now
      |> Timex.shift(months: months)
      |> Timex.format("%b %Y", :strftime)

    pretty_date
  end
end
