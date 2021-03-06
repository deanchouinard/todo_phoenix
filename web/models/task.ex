defmodule Todo.Task do
  use Todo.Web, :model

  schema "tasks" do
    field :date, :string
    field :title, :string
    field :description, :string
    belongs_to :user, Todo.User
    belongs_to :priority, Todo.Priority

    timestamps
  end

  @required_fields ~w(date title description)
  @optional_fields ~w(priority_id)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> assoc_constraint(:priority)
  end
end
