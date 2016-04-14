defmodule Todo.TaskController do
  use Todo.Web, :controller

  alias Todo.Task

  plug :scrub_params, "task" when action in [:create, :update]

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
      [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, user) do
    tasks = Repo.all(user_tasks(user))
    render(conn, "index.html", tasks: tasks)
  end

  def new(conn, _params, user) do
    changeset =
      user
      |> build_assoc(:tasks)
      |> Task.changeset()

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"task" => task_params}, user) do
    changeset =
      user
      |>  build_assoc(:tasks)
      |> Task.changeset(task_params)

    case Repo.insert(changeset) do
      {:ok, _task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: task_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, user) do
    task = Repo.get!(user_tasks(user), id)
    render(conn, "show.html", task: task)
  end

  def edit(conn, %{"id" => id}, user) do
    task = Repo.get!(user_tasks(user), id)
    changeset = Task.changeset(task)
    render(conn, "edit.html", task: task, changeset: changeset)
  end

  def update(conn, %{"id" => id, "task" => task_params}, user) do
    task = Repo.get!(user_tasks(user), id)
    changeset = Task.changeset(task, task_params)

    case Repo.update(changeset) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: task_path(conn, :show, task))
      {:error, changeset} ->
        render(conn, "edit.html", task: task, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, user) do
    task = Repo.get!(user_tasks(user), id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: task_path(conn, :index))
  end

  defp user_tasks(user) do
    assoc(user, :tasks)
  end

end
