defmodule Samwise.SlackTest do
  use Samwise.ConnCase
  alias Samwise.Slack

  test "Wraps message in attachment format" do
    message = "This is a test message"
    expected = %{
      fallback: "This is a test message",
      text: "This is a test message",
      color: "#bfd849",
      author_icon: "https://sam.husk.co/images/apple-touch-icon.png",
    }

    assert Slack.add_options(message) == expected
  end
end
