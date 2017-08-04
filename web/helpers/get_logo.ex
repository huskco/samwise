defmodule Samwise.GetLogo do
  def get_logo(url) do
    if url do
      "https://logo.clearbit.com/#{url}"
    end
  end
end
