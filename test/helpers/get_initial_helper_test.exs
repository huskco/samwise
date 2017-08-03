defmodule Samwise.GetInitialHelperTest do
  use Samwise.ConnCase

  test "gets the initial of a word" do
    assert Samwise.GetInitial.get_initial("Mississippi") == "M"
  end

  test "doesn't return number" do
    assert_raise FunctionClauseError, fn ->
      Samwise.GetInitial.get_initial(5)
    end
  end

  test "doesn't return nil" do
    assert Samwise.GetInitial.get_initial(nil) == ""
  end
end
