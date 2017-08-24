defmodule Samwise.Plugs.AddServiceLayout do
  @moduledoc """
  This module lets a user sign in
  """
  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, service_name) do
    conn
      |> assign(:service_name, service_name)
  end
end
