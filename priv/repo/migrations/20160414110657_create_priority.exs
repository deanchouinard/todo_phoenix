defmodule Todo.Repo.Migrations.CreatePriority do
  use Ecto.Migration

  def change do
    create table(:priorities) do
      add :name, :string, null: false

      timestamps
    end

    create unique_index(:priorities, [:name])
  end
end
