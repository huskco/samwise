defmodule Samwise.Factory do
  @moduledoc """
    Factory to help test users
  """
  use ExMachina.Ecto, repo: Samwise.Repo

  def user_factory do
    %Samwise.User{
      token: "ffnebyt73bich9",
      email: "batman@example.com",
      first_name: "Bruce",
      last_name: "Wayne",
      provider: "google"
    }
  end
end
