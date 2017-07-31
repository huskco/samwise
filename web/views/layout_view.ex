defmodule Samwise.LayoutView do
  use Samwise.Web, :view

  def page_title(conn) do
    if conn.assigns[:page_title] do
      "#{conn.assigns[:page_title]} ◦ Samwise"
    else
      "Samwise"
    end
  end

  def service_nav(conn) do
    if conn.assigns[:service_nav] do
      template = conn.assigns[:service_nav]
      render(template, conn: conn)
    end
  end
end
