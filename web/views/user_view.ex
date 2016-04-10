defmodule Todo.UserView do
  use Todo.Web, :view
  alias Todo.User

  def first_name(%User{name: name}) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end
end

