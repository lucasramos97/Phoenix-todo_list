defmodule TodoListWeb.TodoController do
  use TodoListWeb, :controller

  alias TodoList.Services.TodoService
  alias TodoList.Models.Todo

  action_fallback TodoListWeb.FallbackController

  def index(conn, _params) do
    todos = TodoService.list_todos()
    render(conn, "index.json", todos: todos)
  end

  def create(conn, todo_params) do
    with {:ok, %Todo{} = todo} <- TodoService.create_todo(todo_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.todo_path(conn, :show, todo))
      |> render("show.json", todo: todo)
    end
  end

  def show(conn, %{"id" => id}) do
    todo = TodoService.get_todo(id)

    if nil == todo do
      {:error, :not_found}
    else
      render(conn, "show.json", todo: todo)
    end
  end

  def update(conn, todo_params) do
    todo = TodoService.get_todo(todo_params["id"])

    if nil == todo do
      {:error, :not_found}
    else
      with {:ok, %Todo{} = todo} <- TodoService.update_todo(todo, todo_params) do
        render(conn, "show.json", todo: todo)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    todo = TodoService.get_todo(id)

    if nil == todo do
      {:error, :not_found}
    else
      with {:ok, %Todo{}} <- TodoService.delete_todo(todo) do
        send_resp(conn, :no_content, "")
      end
    end
  end
end
