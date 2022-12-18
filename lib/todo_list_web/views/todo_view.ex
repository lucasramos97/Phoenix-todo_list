defmodule TodoListWeb.TodoView do
  use TodoListWeb, :view
  alias TodoListWeb.TodoView

  def render("index.json", %{todos: todos}) do
    render_many(todos, TodoView, "todo.json")
  end

  def render("show.json", %{todo: todo}) do
    render_one(todo, TodoView, "todo.json")
  end

  def render("todo.json", %{todo: todo}) do
    %{
      id: todo.id,
      text: todo.text,
      completed: todo.completed,
      created_at: todo.inserted_at,
      updated_at: todo.updated_at
    }
  end
end
