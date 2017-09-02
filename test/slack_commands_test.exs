defmodule Samwise.CommandsTest do
  use Samwise.ConnCase
  alias Samwise.Slack.Commands

  test "Respond with friendly daily update with everything" do
    daily_events = [
      insert(:income),
      insert(:bill, %{name: "BillNameA", amount: 100.00, autopay: true}),
      insert(:bill, %{name: "BillNameB", amount: 200.00, autopay: false})
    ]

    summary = Commands.money_summary(daily_events)
    assert summary =~ "Good morning, here is your money update for today:"
    assert summary =~ "It's pay day!"
    refute summary =~ "No bills due today"
    assert summary =~ "*Pay these bills today:* BillNameA ($100.00)"
    assert summary =~ "*Bills coming out automatically:* BillNameB ($200.00)"
  end

  test "Respond with friendly daily update when not pay day" do
    daily_events = [insert(:bill, %{name: "BillNameC", amount: 300.00})]

    summary = Commands.money_summary(daily_events)
    refute summary =~ "It's pay day!"
    refute summary =~ "No bills due today"
    assert summary =~ "*Pay these bills today:* BillNameC ($300.00)"
  end

  test "Respond with friendly daily update when nothing going on" do
    daily_events = []

    summary = Commands.money_summary(daily_events)
    refute summary =~ "It's pay day!"
    assert summary =~ "No bills due today"
    refute summary =~ "Bills coming out automatically"
    refute summary =~ "Pay these bills today"
  end
end
