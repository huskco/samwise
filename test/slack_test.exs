defmodule Samwise.SlackTest do
  use Samwise.ConnCase
  alias Samwise.Slack

  test "Retrieves default bot info" do
    bot_info = Slack.bot_info()
    assert bot_info.author_name == "Samwise"
    assert bot_info.color == "#bfd849"
  end

  test "Retrieves specified bot info" do
    bot_info = Slack.bot_info("money")
    assert bot_info.author_name == "Moneypenny"
    assert bot_info.color == "#f39943"
  end

  test "Wraps message in attachment format" do
    message = "This is a test message"
    expected = [
      %{
        fallback: "This is a test message",
        text: "This is a test message",
        author_name: "Samwise",
        color: "#bfd849",
        author_icon: "https://sam.husk.co/apple-touch-icon.png",
      }
    ]

    assert Slack.to_attachment(message) == expected
  end
end
