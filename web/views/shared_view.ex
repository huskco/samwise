defmodule Samwise.SharedView do
  @moduledoc """
  Shared View for partials
  """
  use Samwise.Web, :view
  alias Phoenix.Controller

  def get_flash(conn) do
    Controller.get_flash(conn)
  end

  def get_emoji(status) do
    case status do
      "info" -> good_emoji()
      "error" -> bad_emoji()
      "danger" -> bad_emoji()
    end
  end

  def good_emoji do
    Enum.random(["😊", "😘", "😸", "🤖", "🤘", "👏", "👍", "👌", "👑", "✨", "⭐️",
      "🍓", "🍑", "🍕", "🍩", "🍰", "🌮", "🍺", "🎉", "🎈"])
  end

  def bad_emoji do
    Enum.random(["😵", "🤢", "😡", "👿", "👹", "💩", "💀", "👎", "🖕", "🔥", "🌪"])
  end
end
