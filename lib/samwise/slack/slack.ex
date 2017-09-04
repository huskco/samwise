defmodule Samwise.Slack do
  @moduledoc """
  A helpful bot for Ogles
  """
  use Slack
  alias Samwise.Slack.Commands

  def handle_connect(slack, state) do
    IO.puts "Connected to Slack as #{slack.me.name}"
    :ets.new(:slack_state, [:named_table])
      |> :ets.insert({"slack", slack})

    {:ok, state}
  end

  # When a message is posted in a channel the bot is in
  # (also checks the last message sent when starting up)

  def handle_event(%{type: "message"} = message, slack, state) do
    slacker_name = lookup_user_name(message.user, slack)
    if slacker_name != ("@" <> slack.me.name) do
      IO.puts "Received Slack message: #{message.text} from #{slacker_name}"
      message.text
        |> Commands.match
        |> send_message(message.channel, slack)
    end

    {:ok, state}
  end
  def handle_event(_, _, state), do: {:ok, state}


  def handle_info({:message, text, channel}, slack, state) do
    send_message(text, channel, slack)
    {:ok, state}
  end
  def handle_info(_, _, state), do: {:ok, state}

  def send_message(message, channel) do
    [{"slack", slack}] = :ets.lookup(:slack_state, "slack")
    send_message(message, channel, slack)
  end

  def post_money_summary do
    channel = System.get_env("SLACK_CHANNEL_MONEY")
    IO.puts "Posting money summary to #{channel}"
    send_message(Commands.money_summary(), channel)
  end
end
