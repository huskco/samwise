defmodule Samwise.Router do
  @moduledoc """
  Router
  """
  use Samwise.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Samwise.Plugs.SetUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/auth", Samwise do
    pipe_through :browser

    get "/signout", AuthController, :delete
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :new
  end

  scope "/", Samwise do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    scope "/money", Money do
      resources "/", MoneyDashboardController, only: [:index]
      resources "/forecast", ForecastController, only: [:index]
      resources "/bills", BillController
      resources "/budgets", BudgetController
      resources "/goals", GoalController
      resources "/incomes", IncomeController
      resources "/bank_account", BankAccountController
    end

    scope "/school", School do
      resources "/", SchoolDashboardController, only: [:index]
      resources "/students", StudentController
      resources "/courses", CourseController
      resources "/classes", ClassController
      resources "/overdues", OverdueController
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", Samwise do
  #   pipe_through :api
  # end
end
