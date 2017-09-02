defmodule Samwise.CommandsTest do
  use Samwise.ConnCase
  alias Samwise.Slack.Commands

  test "Respond with friendly daily update" do
    daily_events = [
      %Samwise.Money.Income{
        amount: 3500,
        due: 12,
        name: "DailyIncome"
      },
      %Samwise.Money.Bill{
        amount: 11.99,
        due: 12,
        name: "DailyBill1",
        url: "example1.com",
        autopay: true
      },
      %Samwise.Money.Bill{
        amount: 9.99,
        due: 12,
        name: "DailyBill2",
        url: "example2.com",
        autopay: false
      }
    ]

    summary = Commands.money_summary(daily_events)
    assert summary =~ "Good morning, here is your money update for today:"
    assert summary =~ "It's pay day!"
    assert summary =~ "Pay these bills today: DailyBill1 ($11.99)"
    assert summary =~ "Bills coming out automatically: DailyBill2 ($9.99)"
  end
end
