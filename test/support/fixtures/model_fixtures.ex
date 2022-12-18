defmodule TodoList.ModelFixtures do
  alias TodoList.Services.TodoService

  def unique_todo_text, do: "some text#{System.unique_integer([:positive])}"

  def todo_fixture(attrs \\ %{}) do
    {:ok, todo} =
      attrs
      |> Enum.into(%{
        completed: true,
        text: unique_todo_text()
      })
      |> TodoService.create_todo()

    todo
  end
end
