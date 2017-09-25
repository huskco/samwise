defmodule Samwise.School.SchoolDashboardController do
  @moduledoc """
  Controller for the School Dashboard
  """
  use Samwise.Web, :controller
  plug Samwise.Plugs.AddServiceLayout, "school"

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
