defmodule Samwise.NextDate do
  use Number

  def pretty_next_date(day, starting_date \\ Timex.today) do
    current_month_datetime(day, starting_date)
    |> next_date(starting_date)
    |> pretty_date
  end

  def current_month_datetime(day, starting_date) do
    starting_date
    |> Timex.format!("%-m/#{day}/%Y", :strftime)
    |> Timex.parse!("{M}/{D}/{YYYY}")
  end

  def next_date(date, starting_date) do
    case Timex.before?(date, starting_date) do
      true -> Timex.shift(date, months: 1)
      false -> date
    end
  end

  def pretty_date(naivedate) do
    month = naivedate.month |> short_month_names()
    day = naivedate.day |> Number.Human.number_to_ordinal()

    "#{month} #{day}"
  end

  def short_month_names(month) do
    names = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    Enum.at(names, month - 1)
  end
end
