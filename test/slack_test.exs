defmodule Samwise.SlackTest do
  use Samwise.ConnCase
  alias Samwise.Slack

  test "Wraps message in attachment format" do
    message = %{message: "This is a test message"}
    expected = %{
      message: "This is a test message",
      username: "Samwise",
      as_user: true
    }

    assert Slack.add_options(message) == expected
  end
end
