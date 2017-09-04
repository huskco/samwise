defmodule Samwise.Scheduler do
  import Quantum

  use Quantum.Scheduler, otp_app: :samwise
end
