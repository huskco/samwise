defmodule Samwise.UpdateSchool do
  @moduledoc """
  This module updates school info
  """

  def update do
    login()
  end

  def login do
    login_url = System.get_env("SCHOOL_URL")
    login_url
  end
end
