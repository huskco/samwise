defmodule Samwise.GetInitial do
  @moduledoc """
  This module gets the initial of the company
  based on the name
  """

  def get_initial(string) do
    String.slice(string, 0..0)
  end
end
