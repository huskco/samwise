defmodule Samwise.Scheduler do
  @moduledoc """
  Performs tasks at specified times using elixir-quantum
  """
  use Quantum.Scheduler, otp_app: :samwise
end
