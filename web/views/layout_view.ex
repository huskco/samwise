defmodule Samwise.LayoutView do
  @moduledoc """
  Handles layouts and helpers
  """
  use Samwise.Web, :view

  def page_title(conn) do
    if conn.assigns[:page_title] do
      "#{conn.assigns[:page_title]} ◦ Samwise"
    else
      "Samwise"
    end
  end

  def service_nav(conn) do
    if conn.assigns[:service_name] do
      render("_service_nav_#{conn.assigns[:service_name]}.html", conn: conn)
    end
  end

  def service_name(conn) do
    conn.assigns[:service_name]
  end
end
