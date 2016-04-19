defmodule Todo.TaskViewTest do
  use Todo.ConnCase, async: true
  import Phoenix.View

  test "renders index.html", %{conn: conn} do
    tasks = [%Todo.Task{id: "1", title: "dogs"},
              %Todo.Task{id: "2", title: "cats"}]
    content = render_to_string(Todo.TaskView, "index.html",
                              conn: conn, tasks: tasks)

    assert String.contains?(content, "Listing tasks")
    for task <- tasks do
      assert String.contains?(content, task.title)
    end
  end

  test "renders new.html", %{conn: conn} do
    changeset = Todo.Task.changeset(%Todo.Task{})
    priorities = [{"cats", 123}]
    content = render_to_string(Todo.TaskView, "new.html",
      conn: conn, changeset: changeset, priorities: priorities)

    assert String.contains?(content, "New task")
  end
end

