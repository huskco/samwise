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
  name: "Netflix",
  amount: 9.99,
  due: 14,
  url: "netflix.com"
}

Repo.insert! %Samwise.Money.Bill{
  name: "Hulu",
  amount: 11.99,
  due: 22,
  url: "hulu.com"
}

Repo.insert! %Samwise.Money.Bill{
  name: "XBox Gold",
  amount: 10.35,
  due: 28,
  url: "xbox.com"
}

Repo.insert! %Samwise.Money.Budget{
  name: "Groceries",
  amount: 600.00,
  url: "walmart.com"
}

Repo.insert! %Samwise.Money.Budget{
  name: "Takeout",
  amount: 150.00
}

Repo.insert! %Samwise.Money.Goal{
  name: "Cushion",
  amount: 3500.00,
  imageUrl: "http://www.doughmain.com/pub/wp-content/uploads/2013/12/Depositphotos_13258500_xs.jpg",
  isDebt: false
}

Repo.insert! %Samwise.Money.Goal{
  name: "Disney World",
  amount: 3500.00,
  url: "disney.com",
  imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/c/ca/1_epcot_spaceship_earth_2010a.JPG/250px-1_epcot_spaceship_earth_2010a.JPG",
  isDebt: false
}

Repo.insert! %Samwise.Money.Income{
  name: "Husk",
  amount: 3500.00,
  dates: [1, 15]
}
