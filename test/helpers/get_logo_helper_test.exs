defmodule Samwise.GetLogoHelperTest do
  use Samwise.ConnCase

  test "gets the initial of a word" do
    assert Samwise.GetLogo.get_logo("netflix.com") == "https://logo.clearbit.com/netflix.com?s=128"
  end

  test "doesn't try with nil" do
    assert Samwise.GetLogo.get_logo(nil) == nil
  end
end
