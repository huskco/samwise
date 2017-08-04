defmodule Samwise.SharedController do
  use Samwise.Web, :controller

  def add_service_layout(conn, service) do
    assign(conn, :service_name, service)
  end
end
