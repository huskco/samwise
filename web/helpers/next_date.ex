defmodule Samwise.NextDate do
  use Number

  def next_date(day, current_date \\ today()) do
    month_name = day
    |> futurize_month(current_date)
    |> simplify_month
    |> short_month_names

    ordinalized_day = Number.Human.number_to_ordinal(day)

    "#{month_name} #{ordinalized_day}"
  end

  def today do
    DateTime.utc_now
  end

  def futurize_month(day, today) do
    case day < today.day do
      true -> today.month + 1
      false -> today.month
    end
  end

  def simplify_month(month) do
    case month > 12 do
      true -> month - 12
      false -> month
    end
  end

  def short_month_names(month) do
    names = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    Enum.at(names, month - 1)
  end
end
