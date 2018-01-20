defmodule Samwise.Scheduler do
  @moduledoc """
    Scheduler to run cron tasks
  """
  use Quantum.Scheduler, otp_app: :samwise
end
