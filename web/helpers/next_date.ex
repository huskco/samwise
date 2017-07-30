defmodule Samwise.NextDate do
  use Number

  def next_date(day) do
    if day < today.day do
      month = today.month + 1
    else
      month = today.month
    end

    if month > 12 do
      month = month - 12
      year = today.year + 1
    else
      year = today.year
    end

    month_name = short_month_names(month)
    ordinalized_day = Number.Human.number_to_ordinal(day)

    "#{month_name} #{ordinalized_day}"
  end

  def today do
    DateTime.utc_now
  end

  def short_month_names(month) do
    names = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    Enum.at(names, month - 1)
  end
end
