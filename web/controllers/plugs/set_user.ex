defmodule Samwise.Plugs.SetUser do
  @moduledoc """
  This module lets a user sign in
  """
  import Plug.Conn

  alias Samwise.Repo
  alias Samwise.User

  def init(_params) do
  end

  def call(conn, _params) do
    if conn.assigns[:user] do
      conn
    else
      user_id = get_session(conn, :user_id)

      user = case user_id do
        nil -> nil
        _ -> Repo.get(User, user_id)
      end

      assign(conn, :user, user)
    end
  end
end
