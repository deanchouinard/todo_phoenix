defmodule Todo.Repo.Migrations.AddPriorityIdToTask do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add :priority_id, references(:priorities)
    end
  end
end
