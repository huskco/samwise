defmodule Samwise.GetLogo do
  @moduledoc """
  This module gets the logo of the company
  using the Clearbit Logo API
  """

  def get_logo(url) do
    if url do
      "https://logo.clearbit.com/#{url}"
    end
  end
end
