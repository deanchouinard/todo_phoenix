defmodule Todo.PriorityTest do
  use Todo.ModelCase

  alias Todo.Priority

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Priority.changeset(%Priority{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Priority.changeset(%Priority{}, @invalid_attrs)
    refute changeset.valid?
  end
end
