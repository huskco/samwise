defmodule Samwise.GetLogoHelperTest do
  use Samwise.ConnCase
  alias Samwise.GetLogo

  test "gets the initial of a word" do
    expected = "https://logo.clearbit.com/netflix.com"
    assert GetLogo.get_logo("netflix.com") == expected
  end

  test "doesn't try with nil" do
    assert GetLogo.get_logo(nil) == nil
  end
end
