defmodule Samwise.NextDateHelperTest do
  use Samwise.ConnCase

  test "displays the pretty next date for this month" do
    today = ~N[2017-02-25 12:00:00.0]
    assert Samwise.NextDate.next_date(28, today) == "Feb 28th"
  end

  test "displays the pretty next date for next month" do
    today = ~N[2017-02-25 12:00:00.0]
    assert Samwise.NextDate.next_date(22, today) == "Mar 22nd"
  end

  test "changes to the next month if date passed" do
    today = ~N[2017-02-23 23:00:00.0]
    assert Samwise.NextDate.futurize_month(22, today) == 3
  end

  test "do not change to the next month if date hasn't passed" do
    today = ~N[2017-02-23 23:00:00.0]
    assert Samwise.NextDate.futurize_month(25, today) == 2
  end

  test "simplifies month if given one more than 12" do
    assert Samwise.NextDate.simplify_month(15) == 3
  end

  test "does not simplify month if given one less than 12" do
    assert Samwise.NextDate.simplify_month(4) == 4
  end

  test "gets month name from shortnames" do
    assert Samwise.NextDate.short_month_names(5) == "May"
  end
end
