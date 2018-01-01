defmodule Samwise.SmartDate do
  @moduledoc """
  This module includes helpers to transform dates
  into more readable strings or to determine
  how dates relate to each other
  """

  alias Number.Human

  def pretty_next_date(day, starting_date \\ Timex.today) do
    day
      |> current_month_datetime(starting_date)
      |> next_date(starting_date)
      |> pretty_date(:day)
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

  def simple_date(date) do
    date_string = Timex.format(date, "%m/%d/%Y", :strftime)

    case date_string do
      {:ok, string} -> string
      {:error, reason} -> reason
    end
  end

  def pretty_date(naivedate, :day) do
    month = naivedate.month |> short_month_names()
    day = naivedate.day |> Human.number_to_ordinal()

    "#{month} #{day}"
  end

  def pretty_date(naivedate, :month) do
    {:ok, date} = naivedate
      |> Timex.format("%b %Y", :strftime)
    date
  end

  def short_month_names(month) do
    names = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    Enum.at(names, month - 1)
  end
end
