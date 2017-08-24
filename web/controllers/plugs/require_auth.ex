defmodule Samwise.Plugs.RequireAuth do
  @moduledoc """
  This module helps determind if a user is signed in
  """
  import Plug.Conn
  import Phoenix.Controller

  def init(_params) do
  end

  def call(conn, _params) do
    if conn.assigns[:user] do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in.")
      |> redirect(to: "/")
      |> halt()
    end
  end
end
