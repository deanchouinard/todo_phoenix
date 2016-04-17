defmodule Todo.TestHelpers do
  alias Todo.Repo

  def insert_user(attrs \\ %{}) do
    changes = Dict.merge(%{
      name: "Some User",
      username: "user#{Base.encode16(:crypto.rand_bytes(8))}",
      password: "supersecret",
    }, attrs)

    %Todo.User{}
    |> Todo.User.registration_changeset(changes)
    |> Repo.insert!()
  end

  def insert_task(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:tasks, attrs)
    |> Repo.insert!()
  end
end
