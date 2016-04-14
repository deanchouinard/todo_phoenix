# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Todo.Repo.insert!(%Todo.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Todo.Repo
alias Todo.Priority

for priority <- ~w(Low Medium High Ongoing) do
  Repo.get_by(Priority, name: priority) ||
    Repo.insert!(%Priority{name: priority})
end

