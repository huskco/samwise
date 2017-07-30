defmodule Samwise.LayoutView do
  use Samwise.Web, :view

  def page_title(conn) do
    if conn.assigns[:page_title] do
      "#{conn.assigns[:page_title]} - Samwise"
    else
      "Samwise"
    end
  end

  def sidebar(conn) do
    if conn.assigns[:sidebar] do
      template = conn.assigns[:sidebar]
      render(template, conn: conn)
    end
  end
end
