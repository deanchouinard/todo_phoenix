defmodule Todo.UserController do
  use Todo.Web, :controller
  alias Todo.User

  def index(conn, _params) do
    users = Repo.all(Todo.User)
    render conn, "index.html", users: users
  end

  def show(conn, %{"id" => id} = params) do
    user = Repo.get(Todo.User, id)
    render conn, "show.html", user: user
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params} = params) do
    changeset = User.changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

end

