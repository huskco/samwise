defmodule Samwise.Slack do
  @moduledoc """
  A helpful bot for Ogles
  """
  use Slack
  alias Slack.Web.Chat
  alias Samwise.Slack.Commands

  def handle_connect(slack, state) do
    IO.puts "Connected to Slack as #{slack.me.name}"
    :slack_state
      |> :ets.new([:named_table])
      |> :ets.insert({"slack", slack})

    {:ok, state}
  end

  # When a message is posted in a channel the bot is in
  # (also checks the last message sent when starting up)

  def handle_event(%{type: "message"} = message, slack, state) do
    if is_command(message, slack) do
      request = demention(message, slack)
      response = Commands.match(request)
      options = add_options(response[:options])
      message.channel
        |> Chat.post_message(response.message, options)
    end
    {:ok, state}
  end
  def handle_event(_, _, state), do: {:ok, state}

  def handle_info({:message, text, channel}, slack, state) do
    send_message(text, channel, slack)
    {:ok, state}
  end
  def handle_info(_, _, state), do: {:ok, state}

  # Detects if a message should be responded to
  def is_command(message, slack) do
    is_from_user = Map.has_key?(message, :user)
    is_mention = String.starts_with?(message.text, "<@#{slack.me.id}>")
    is_direct_message = String.starts_with?(message.channel, "D")
    is_from_user && (is_mention || is_direct_message)
  end

  def demention(message, slack) do
    direct_message_starts = "<@#{slack.me.id}> "
    if String.starts_with?(message.text, direct_message_starts) do
      String.trim(message.text, direct_message_starts)
    else
      message.text
    end
  end

  # Send messages from anywhere in the app:
  # Samwise.Slack.send_message(message, channel)

  def send_message(message, channel) do
    [{"slack", slack}] = :ets.lookup(:slack_state, "slack")
    send_message(message, channel, slack)
  end

  def add_options(options) do
    defaults = %{
      username: "Samwise",
      as_user: true,
      mrkdwn: true,
    }

    case options != nil do
      true -> Map.merge(defaults, options)
      false -> defaults
    end
  end

  # Scheduled tasks

  def post_money_summary do
    channel = System.get_env("SLACK_CHANNEL_MONEY")
    IO.puts "Posting money summary to #{channel}"

    response = Commands.money_summary()
    options = add_options(response.options)

    channel
      |> Chat.post_message(response.message, options)
  end
end
