defmodule TodoList.Services.TodoServiceTest do
  use TodoList.DataCase

  alias TodoList.Services.TodoService

  describe "todos" do
    alias TodoList.Models.Todo

    import TodoList.ModelFixtures

    @invalid_attrs %{completed: nil, text: nil}

    test "list_todos/0 returns all todos" do
      todo = todo_fixture()
      assert TodoService.list_todos() == [todo]
    end

    test "get_todo/1 returns the todo with given id" do
      todo = todo_fixture()
      assert TodoService.get_todo(todo.id) == todo
    end

    test "create_todo/1 with valid data creates a todo" do
      valid_attrs = %{completed: true, text: "some text"}

      assert {:ok, %Todo{} = todo} = TodoService.create_todo(valid_attrs)
      assert todo.completed == true
      assert todo.text == "some text"
    end

    test "create_todo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TodoService.create_todo(@invalid_attrs)
    end

    test "update_todo/2 with valid data updates the todo" do
      todo = todo_fixture()
      update_attrs = %{completed: false, text: "some updated text"}

      assert {:ok, %Todo{} = todo} = TodoService.update_todo(todo, update_attrs)
      assert todo.completed == false
      assert todo.text == "some updated text"
    end

    test "update_todo/2 with invalid data returns error changeset" do
      todo = todo_fixture()
      assert {:error, %Ecto.Changeset{}} = TodoService.update_todo(todo, @invalid_attrs)
      assert todo == TodoService.get_todo(todo.id)
    end

    test "delete_todo/1 deletes the todo" do
      todo = todo_fixture()
      assert {:ok, %Todo{}} = TodoService.delete_todo(todo)
      assert nil == TodoService.get_todo(todo.id)
    end

    test "change_todo/1 returns a todo changeset" do
      todo = todo_fixture()
      assert %Ecto.Changeset{} = TodoService.change_todo(todo)
    end
  end
end
