# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Samwise.Repo.insert!(%Samwise.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Samwise.Repo

Repo.insert! %Samwise.Money.Bill{
  name: "BillName",
  amount: 9.99,
  due: 14,
  url: "netflix.com"
}

Repo.insert! %Samwise.Money.Bill{
  name: "BillName",
  amount: 11.99,
  due: 22,
  url: "hulu.com"
}

Repo.insert! %Samwise.Money.Bill{
  name: "BillName",
  amount: 10.35,
  due: 28,
  url: "xbox.com"
}

Repo.insert! %Samwise.Money.Budget{
  name: "BudgetName",
  amount: 600.00,
  url: "walmart.com"
}

Repo.insert! %Samwise.Money.Budget{
  name: "BudgetName",
  amount: 150.00
}

Repo.insert! %Samwise.Money.Goal{
  name: "GoalName",
  amount: 3500.00,
  imageUrl: "http://www.doughmain.com/pub/wp-content/uploads/2013/12/Depositphotos_13258500_xs.jpg",
  isDebt: false
}

Repo.insert! %Samwise.Money.Goal{
  name: "GoalName",
  amount: 3500.00,
  url: "disney.com",
  imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/c/ca/1_epcot_spaceship_earth_2010a.JPG/250px-1_epcot_spaceship_earth_2010a.JPG",
  isDebt: false
}

Repo.insert! %Samwise.Money.Income{
  name: "IncomeName",
  amount: 3500.00,
  due: 1
}

Repo.insert! %Samwise.Money.Income{
  name: "IncomeName",
  amount: 3500.00,
  due: 15
}

Repo.insert! %Samwise.Money.BankAccount{
  balance: 1000.00,
  savings: 1000.00,
  cushion: 1000.00
}
