defmodule Samwise.Router do
  use Samwise.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Samwise do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/money/bills", Money.BillController
    resources "/money/budgets", Money.BudgetController
    resources "/money/goals", Money.GoalController
    resources "/money/incomes", Money.IncomeController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Samwise do
  #   pipe_through :api
  # end
end
