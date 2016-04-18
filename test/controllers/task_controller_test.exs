defmodule Todo.TaskControllerTest do
  use Todo.ConnCase

  test "requires user authentication on all actions", %{conn: conn} do
    Enum.each([
      get(conn, task_path(conn, :new)),
      get(conn, task_path(conn, :index)),
      get(conn, task_path(conn, :show, "123")),
      get(conn, task_path(conn, :edit, "123")),
      put(conn, task_path(conn, :update, "123", %{})),
      post(conn, task_path(conn, :create, %{})),
      delete(conn, task_path(conn, :delete, "123")),
    ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end

  setup %{conn: conn} = config do
    if username = config[:login_as] do
      user = insert_user(username: username)
      conn = assign(conn(), :current_user, user)
      {:ok, conn: conn, user: user}
    else
      :ok
    end
  end

  @tag login_as: "max"
  test "lists all user's tasks on index", %{conn: conn, user: user} do
    user_task = insert_task(user, title: "funny cats")
    other_task = insert_task(insert_user(username: "other"), title: "another
    task")

    conn = get conn, task_path(conn, :index)
    assert html_response(conn, 200) =~ ~r/Listing tasks/
    assert String.contains?(conn.resp_body, user_task.title)
    refute String.contains?(conn.resp_body, other_task.title)
  end

  alias Todo.Task
  @valid_attrs %{date: "2015/03/04", title: "Shopping", description: "a vid"}
  @invalid_attrs %{title: "invalid"}

  defp task_count(query), do: Repo.one(from v in query, select: count(v.id))

  @tag login_as: "max"
  test "create user task and redirects", %{conn: conn, user: user} do
    conn = post conn, task_path(conn, :create), task: @valid_attrs
    assert redirected_to(conn) == task_path(conn, :index)
    assert Repo.get_by!(Task, @valid_attrs).user_id == user.id
  end

  @tag login_as: "max"
  test "does not create task and render error when invalid", %{conn: conn} do
    count_before = task_count(Task)
    conn = post conn, task_path(conn, :create), task: @invalid_attrs
    assert html_response(conn, 200) =~ "check the errors"
    assert task_count(Task) == count_before
  end

  @tag login_as: "max"
  test "authorizes actions against access by other users",
    %{user: owner, conn: conn} do

      task = insert_task(owner, @valid_attrs)
      non_owner = insert_user(username: "sneaky")
      conn = assign(conn, :current_user, non_owner)

      assert_error_sent :not_found, fn ->
        get(conn, task_path(conn, :show, task))
      end
      assert_error_sent :not_found, fn ->
        get(conn, task_path(conn, :edit, task))
      end
      assert_error_sent :not_found, fn ->
        put(conn, task_path(conn, :update, task, task: @valid_attrs))
      end
      assert_error_sent :not_found, fn ->
        delete(conn, task_path(conn, :delete, task))
      end
  end
end
