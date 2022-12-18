defmodule TodoList.Services.TodoService do
  import Ecto.Query, warn: false

  alias TodoList.Repo
  alias TodoList.Models.Todo

  def list_todos do
    Todo |> order_by(asc: :id) |> Repo.all()
  end

  def get_todo(id), do: Repo.get(Todo, id)

  def create_todo(attrs \\ %{}) do
    %Todo{}
    |> Todo.changeset(attrs)
    |> Repo.insert()
  end

  def update_todo(%Todo{} = todo, attrs) do
    todo
    |> Todo.changeset(attrs)
    |> Repo.update()
  end

  def delete_todo(%Todo{} = todo) do
    Repo.delete(todo)
  end

  def change_todo(%Todo{} = todo, attrs \\ %{}) do
    Todo.changeset(todo, attrs)
  end
end
