defmodule Samwise.GetInitialHelperTest do
  use Samwise.ConnCase
  alias Samwise.GetInitial

  test "gets the initial of a word" do
    assert GetInitial.get_initial("Mississippi") == "M"
  end

  test "doesn't return number" do
    assert_raise FunctionClauseError, fn ->
      GetInitial.get_initial(5)
    end
  end

  test "doesn't return nil" do
    assert GetInitial.get_initial(nil) == ""
  end
end
