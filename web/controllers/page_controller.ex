defmodule Samwise.PageController do
  use Samwise.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
