defmodule Todo.UserController do
  use Todo.Web, :controller

  def index(conn, _params) do
    users = Repo.all(Todo.User)
    render conn, "index.html", users: users
  end

  def show(conn, %{"id" => id} = params) do
    user = Repo.get(Todo.User, id)
    render conn, "show.html", user: user
  end
end

