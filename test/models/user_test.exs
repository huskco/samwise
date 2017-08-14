defmodule Samwise.UserTest do
  use Samwise.ModelCase
  alias Samwise.User

  @valid_attrs %{token: "fahoifhaoaew0rheh0", email: "batman@example.com",
                 first_name: "Bruce", last_name: "Wayne", provider: "google"}
  @invalid_attrs %{}

  test "changeset with valide attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
