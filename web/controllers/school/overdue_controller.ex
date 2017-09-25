defmodule Samwise.School.OverdueController do
  @moduledoc """
  Controller for Overdue Assignments
  """
  use Samwise.Web, :controller
  plug Samwise.Plugs.AddServiceLayout, "school"

  alias Samwise.School.Overdue

  def index(conn, _params) do
    overdues = Repo.all(Overdue)
    render(conn, "index.html", overdues: overdues)
  end

  def new(conn, _params) do
    changeset = Overdue.changeset(%Overdue{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"overdue" => overdue_params}) do
    changeset = Overdue.changeset(%Overdue{}, overdue_params)

    case Repo.insert(changeset) do
      {:ok, overdue} ->
        conn
        |> put_flash(:info, "Overdue created successfully.")
        |> redirect(to: overdue_path(conn, :show, overdue))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    overdue = Repo.get!(Overdue, id)
    render(conn, "show.html", overdue: overdue)
  end

  def edit(conn, %{"id" => id}) do
    overdue = Repo.get!(Overdue, id)
    changeset = Overdue.changeset(overdue)
    render(conn, "edit.html", overdue: overdue, changeset: changeset)
  end

  def update(conn, %{"id" => id, "overdue" => overdue_params}) do
    overdue = Repo.get!(Overdue, id)
    changeset = Overdue.changeset(overdue, overdue_params)

    case Repo.update(changeset) do
      {:ok, overdue} ->
        conn
        |> put_flash(:info, "Overdue updated successfully.")
        |> redirect(to: overdue_path(conn, :show, overdue))
      {:error, changeset} ->
        render(conn, "edit.html", overdue: overdue, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    overdue = Repo.get!(Overdue, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(overdue)

    conn
    |> put_flash(:info, "Overdue deleted successfully.")
    |> redirect(to: overdue_path(conn, :index))
  end
end
