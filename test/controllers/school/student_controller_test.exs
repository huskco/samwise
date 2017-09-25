defmodule Samwise.School.StudentControllerTest do
  use Samwise.ConnCase

  alias Samwise.School.Student
  @valid_attrs %{name: "some name"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, student_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing students"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, student_path(conn, :new)
    assert html_response(conn, 200) =~ "New student"
  end

  test "creates and redirects when data is valid", %{conn: conn} do
    conn = post conn, student_path(conn, :create), student: @valid_attrs
    student = Repo.get_by!(Student, @valid_attrs)
    assert redirected_to(conn) == student_path(conn, :show, student.id)
  end

  test "doesnt create and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, student_path(conn, :create), student: @invalid_attrs
    assert html_response(conn, 200) =~ "New student"
  end

  test "shows chosen resource", %{conn: conn} do
    student = Repo.insert! %Student{}
    conn = get conn, student_path(conn, :show, student)
    assert html_response(conn, 200) =~ "Show student"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, student_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    student = Repo.insert! %Student{}
    conn = get conn, student_path(conn, :edit, student)
    assert html_response(conn, 200) =~ "Edit student"
  end

  test "updates and redirects when data is valid", %{conn: conn} do
    student = Repo.insert! %Student{}
    conn = put conn, student_path(conn, :update, student), student: @valid_attrs
    assert redirected_to(conn) == student_path(conn, :show, student)
    assert Repo.get_by(Student, @valid_attrs)
  end

  test "doesnt update and renders errors when data is invalid", %{conn: conn} do
    student = Repo.insert! %Student{}
    conn = conn
      |> put(student_path(conn, :update, student), student: @invalid_attrs)
    assert html_response(conn, 200) =~ "Edit student"
  end

  test "deletes chosen resource", %{conn: conn} do
    student = Repo.insert! %Student{}
    conn = delete conn, student_path(conn, :delete, student)
    assert redirected_to(conn) == student_path(conn, :index)
    refute Repo.get(Student, student.id)
  end
end
