defmodule Samwise.Slack do
  @moduledoc """
  A helpful bot for Ogles
  """
  use Slack

  alias Samwise.Money.BankAccountController
  alias Samwise.Money.ForecastController
  alias Number.Currency

  def handle_connect(slack, state) do
    IO.puts "Connected to Slack as #{slack.me.name}"
    {:ok, state}
  end

  def handle_event(%{type: "message"} = message, slack, state) do
    slacker_name = lookup_user_name(message.user, slack)
    if slacker_name != ("@" <> slack.me.name) do
      IO.puts "Received Slack message: #{message.text} from #{slacker_name}"
      message.text
        |> match_commands(slacker_name)
        |> send_message(message.channel, slack)
    end

    {:ok, state}
  end
  def handle_event(_, _, state), do: {:ok, state}

  def handle_info({:message, text, channel}, slack, state) do
    IO.puts "Sending your message, captain!"

    send_message(text, channel, slack)

    {:ok, state}
  end
  def handle_info(_, _, state), do: {:ok, state}

  def match_commands(text, _slacker_name) do
    case text do
      "What is my balance" -> handle_balance()
      "How much can I spend" -> handle_available_to_spend()
      # _ -> "Sorry #{slacker_name}, I didn't understand that"
    end
  end

  # Known commands

  def handle_balance do
    balance = BankAccountController.balance()
      |> Currency.number_to_currency

    savings = BankAccountController.savings()
      |> Currency.number_to_currency

    "Your balance is #{balance}, with #{savings} in savings"
  end

  def handle_available_to_spend do
    available_to_spend = ForecastController.get_available_to_spend()
      |> Currency.number_to_currency

    "You have #{available_to_spend} available"
  end
end
