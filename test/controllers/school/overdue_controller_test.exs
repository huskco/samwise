defmodule Samwise.School.OverdueControllerTest do
  use Samwise.ConnCase

  alias Samwise.School.Overdue
  @valid_attrs %{due: ~N[2010-04-17 14:00:00.000000], name: "some name"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, overdue_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing overdues"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, overdue_path(conn, :new)
    assert html_response(conn, 200) =~ "New overdue"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, overdue_path(conn, :create), overdue: @valid_attrs
    overdue = Repo.get_by!(Overdue, @valid_attrs)
    assert redirected_to(conn) == overdue_path(conn, :show, overdue.id)
  end

  test "doesnt create and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, overdue_path(conn, :create), overdue: @invalid_attrs
    assert html_response(conn, 200) =~ "New overdue"
  end

  test "shows chosen resource", %{conn: conn} do
    overdue = Repo.insert! %Overdue{}
    conn = get conn, overdue_path(conn, :show, overdue)
    assert html_response(conn, 200) =~ "Show overdue"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, overdue_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    overdue = Repo.insert! %Overdue{}
    conn = get conn, overdue_path(conn, :edit, overdue)
    assert html_response(conn, 200) =~ "Edit overdue"
  end

  test "updates and redirects when data is valid", %{conn: conn} do
    overdue = Repo.insert! %Overdue{}
    conn = put conn, overdue_path(conn, :update, overdue), overdue: @valid_attrs
    assert redirected_to(conn) == overdue_path(conn, :show, overdue)
    assert Repo.get_by(Overdue, @valid_attrs)
  end

  test "doesnt update and renders errors when data is invalid", %{conn: conn} do
    overdue = Repo.insert! %Overdue{}
    conn = conn
      |> put(overdue_path(conn, :update, overdue), overdue: @invalid_attrs)
    assert html_response(conn, 200) =~ "Edit overdue"
  end

  test "deletes chosen resource", %{conn: conn} do
    overdue = Repo.insert! %Overdue{}
    conn = delete conn, overdue_path(conn, :delete, overdue)
    assert redirected_to(conn) == overdue_path(conn, :index)
    refute Repo.get(Overdue, overdue.id)
  end
end
