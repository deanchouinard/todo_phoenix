defmodule Todo.PriorityRepoTest do
  use Todo.ModelCase
  alias Todo.Priority

  test "alphabetical/1 orders by name" do
    Repo.insert!(%Priority{name: "c"})
    Repo.insert!(%Priority{name: "a"})
    Repo.insert!(%Priority{name: "b"})

    query = Priority |> Priority.alphabetical()
    query = from c in query, select: c.name
    assert Repo.all(query) == ~w(a b c)
  end
end


