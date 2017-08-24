defmodule Samwise.PageController do
  @moduledoc """
    Controller for generic pages
  """
  use Samwise.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
