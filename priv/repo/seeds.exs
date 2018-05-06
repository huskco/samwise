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
  url: "http://netflix.com"
}

Repo.insert! %Samwise.Money.Budget{
  name: "BudgetName",
  amount: 600.00,
  url: "http://walmart.com"
}

Repo.insert! %Samwise.Money.Goal{
  name: "GoalName",
  amount: 3500.00,
  url: "http://disney.com",
  imageUrl: "http://logos.wikia.com/wiki/File:Disney_Logo.png",
  isDebt: false
}

Repo.insert! %Samwise.Money.Income{
  name: "IncomeName",
  amount: 3500.00,
  due: 1
}

Repo.insert! %Samwise.Money.BankAccount{
  balance: 1000.00,
  savings: 1000.00,
  cushion: 1000.00
}

Repo.insert! %Samwise.School.Student{
  name: "Student1"
}

Repo.insert! %Samwise.School.Course{
  name: "Course1",
  grade: 90.00,
  student_id: 1
}

Repo.insert! %Samwise.School.Class{
  name: "Class1",
  start_time: "9:00 AM",
  end_time: "9:45 AM",
  required: true,
  course_id: 1
}

Repo.insert! %Samwise.School.Overdue{
  name: "Overdue1",
  due: DateTime.utc_now,
  course_id: 1
}
