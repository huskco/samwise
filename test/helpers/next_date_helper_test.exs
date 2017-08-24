defmodule Samwise.NextDateHelperTest do
  use Samwise.ConnCase
  alias Samwise.NextDate

  test "converts day to date in current month" do
    starting_date = Timex.parse!("02/28/1982", "%-m/%-d/%Y", :strftime)
    expected = ~N[1982-02-05 00:00:00]
    assert NextDate.current_month_datetime(5, starting_date) == expected
  end

  test "makes a date simple" do
    date = Timex.parse!("02/23/1982", "%-m/%-d/%Y", :strftime)
    assert NextDate.simple_date(date) == "02/23/1982"
  end

  test "makes a date pretty" do
    date = Timex.parse!("02/23/1982", "%-m/%-d/%Y", :strftime)
    assert NextDate.pretty_date(date) == "Feb 23rd"
  end

  test "shifts to next month if passed" do
    current_month_date = Timex.parse!("02/11/1982", "%-m/%-d/%Y", :strftime)
    starting_date = Timex.parse!("02/23/1982", "%-m/%-d/%Y", :strftime)
    expected = ~N[1982-03-11 00:00:00]
    assert NextDate.next_date(current_month_date, starting_date) == expected
  end

  test "doesn't shift to next month if not passed" do
    current_month_date = Timex.parse!("02/23/1982", "%-m/%-d/%Y", :strftime)
    starting_date = Timex.parse!("02/15/1982", "%-m/%-d/%Y", :strftime)
    expected = ~N[1982-02-23 00:00:00]
    assert NextDate.next_date(current_month_date, starting_date) == expected
  end

  test "converts day to pretty date in next month" do
    starting_date = Timex.parse!("02/23/1982", "%-m/%-d/%Y", :strftime)
    assert NextDate.pretty_next_date(5, starting_date) == "Mar 5th"
  end
end
