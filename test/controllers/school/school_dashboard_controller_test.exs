defmodule Samwise.School.SchoolDashboardControllerTest do
  use Samwise.ConnCase

  alias Samwise.School.SchoolDashboard
  @valid_attrs %{}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, school_dashboard_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing school dashboard"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, school_dashboard_path(conn, :new)
    assert html_response(conn, 200) =~ "New school dashboard"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, school_dashboard_path(conn, :create), school_dashboard: @valid_attrs
    school_dashboard = Repo.get_by!(SchoolDashboard, @valid_attrs)
    assert redirected_to(conn) == school_dashboard_path(conn, :show, school_dashboard.id)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, school_dashboard_path(conn, :create), school_dashboard: @invalid_attrs
    assert html_response(conn, 200) =~ "New school dashboard"
  end

  test "shows chosen resource", %{conn: conn} do
    school_dashboard = Repo.insert! %SchoolDashboard{}
    conn = get conn, school_dashboard_path(conn, :show, school_dashboard)
    assert html_response(conn, 200) =~ "Show school dashboard"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, school_dashboard_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    school_dashboard = Repo.insert! %SchoolDashboard{}
    conn = get conn, school_dashboard_path(conn, :edit, school_dashboard)
    assert html_response(conn, 200) =~ "Edit school dashboard"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    school_dashboard = Repo.insert! %SchoolDashboard{}
    conn = put conn, school_dashboard_path(conn, :update, school_dashboard), school_dashboard: @valid_attrs
    assert redirected_to(conn) == school_dashboard_path(conn, :show, school_dashboard)
    assert Repo.get_by(SchoolDashboard, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    school_dashboard = Repo.insert! %SchoolDashboard{}
    conn = put conn, school_dashboard_path(conn, :update, school_dashboard), school_dashboard: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit school dashboard"
  end

  test "deletes chosen resource", %{conn: conn} do
    school_dashboard = Repo.insert! %SchoolDashboard{}
    conn = delete conn, school_dashboard_path(conn, :delete, school_dashboard)
    assert redirected_to(conn) == school_dashboard_path(conn, :index)
    refute Repo.get(SchoolDashboard, school_dashboard.id)
  end
end
