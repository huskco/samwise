defmodule Samwise.CommandsTest do
  use Samwise.ConnCase
  alias Samwise.Slack.Commands

  test "Respond with friendly daily update with everything" do
    insert(
      :bank_account,
      name: "Checking",
      amount: 10000.00,
      is_available: true,
      is_investment: false,
      is_allowance: false,
      show_on_dashboard: true,
      comments: "some content"
    )
    daily_events = [
      insert(:income, amount: 5000.00),
      insert(:bill, %{name: "BillNameA", amount: 100.00, autopay: true}),
      insert(:bill, %{name: "BillNameB", amount: 200.00, autopay: false})
    ]

    result = Commands.money_summary(daily_events, 10000, 5000, false)
    {:ok, attachments} = [
      %{
        text: "You have $10,000.00 available (*$5,000.00 safe to spend*)",
        mrkdwn_in: ["text"],
        color: "#bfd849"
      },
      %{
        text: "It's pay day! ",
        color: "#bfd849"
      },
      %{
        text: "*Bills coming out automatically:* BillNameA ($100.00)",
        mrkdwn_in: ["text"],
        color: "#f4da5c"
      },
      %{
        text: "*Pay these bills today:* BillNameB ($200.00)",
        mrkdwn_in: ["text"],
        color: "#f15729"
      }
    ] |> Poison.encode
    expected = %{
      message: "Good morning, here is your money update for today:",
      options: %{
        attachments: attachments
      }
    }
    assert result == expected
  end

  test "Respond with friendly daily update when not pay day" do
    daily_events = [insert(:bill, %{name: "BillNameC", amount: 300.00})]

    result = Commands.money_summary(daily_events, 3000, 1000, false)
    {:ok, attachments} = [
      %{
        text: "You have $3,000.00 available (*$1,000.00 safe to spend*)",
        mrkdwn_in: ["text"],
        color: "#bfd849"
      },
      %{
        text: "*Bills coming out automatically:* BillNameC ($300.00)",
        mrkdwn_in: ["text"],
        color: "#f4da5c"
      }
    ] |> Poison.encode
    expected = %{
      message: "Good morning, here is your money update for today:",
      options: %{
        attachments: attachments
      }
    }
    assert result == expected
  end

  test "Respond with friendly daily update when nothing going on" do
    daily_events = []

    result = Commands.money_summary(daily_events, 8500, 1250, false)
    {:ok, attachments} = [
      %{
        text: "You have $8,500.00 available (*$1,250.00 safe to spend*)",
        mrkdwn_in: ["text"],
        color: "#bfd849"
      },
      %{
        text: "No bills due today! ",
        color: "#ebe8e6"
      }
    ] |> Poison.encode
    expected = %{
      message: "Good morning, here is your money update for today:",
      options: %{
        attachments: attachments
      }
    }
    assert result == expected
  end
end
