defmodule TodoListWeb.TodoControllerTest do
  use TodoListWeb.ConnCase

  import TodoList.ModelFixtures

  alias TodoList.Models.Todo

  @id_todo_nonexistent 9999
  @default_text "some text"

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_todos]

    test "lists all todos", %{conn: conn} do
      conn = get(conn, Routes.todo_path(conn, :index))

      assert length(json_response(conn, 200)) == 5
    end
  end

  describe "create todo" do
    test "renders todo when data is valid", %{conn: conn} do
      conn = post(conn, Routes.todo_path(conn, :create), %{text: @default_text, completed: true})

      assert %{
               "id" => _,
               "text" => @default_text,
               "completed" => true,
               "created_at" => _,
               "updated_at" => _
             } = json_response(conn, 201)
    end

    test "renders todo when only text field is informed", %{conn: conn} do
      conn = post(conn, Routes.todo_path(conn, :create), %{text: @default_text})

      assert %{
               "id" => _,
               "text" => @default_text,
               "completed" => false,
               "created_at" => _,
               "updated_at" => _
             } = json_response(conn, 201)
    end

    test "renders error when text field is not informed", %{conn: conn} do
      conn = post(conn, Routes.todo_path(conn, :create), %{text: nil})

      assert %{"message" => "Text field not informed!"} = json_response(conn, 412)
    end

    test "renders error when text field is already informed", %{conn: conn} do
      post(conn, Routes.todo_path(conn, :create), %{text: @default_text})
      conn = post(conn, Routes.todo_path(conn, :create), %{text: @default_text})

      assert %{
               "message" => "The todo '#{@default_text}' already exists!"
             } == json_response(conn, 412)
    end
  end

  describe "show todo" do
    setup [:create_todo]

    test "renders todo when is found", %{conn: conn, todo: %Todo{id: id} = todo} do
      conn = get(conn, Routes.todo_path(conn, :show, todo))

      assert %{
               "id" => ^id,
               "text" => _,
               "completed" => true,
               "created_at" => _,
               "updated_at" => _
             } = json_response(conn, 200)
    end

    test "renders error when todo is not found", %{conn: conn} do
      conn = get(conn, Routes.todo_path(conn, :show, %Todo{id: @id_todo_nonexistent}))

      assert %{
               "message" => "Todo not found with id #{@id_todo_nonexistent}!"
             } == json_response(conn, 404)
    end
  end

  describe "update todo" do
    setup [:create_todo]

    test "renders todo when data is valid", %{conn: conn, todo: %Todo{id: id} = todo} do
      conn =
        put(conn, Routes.todo_path(conn, :update, todo), %{
          text: "some updated text",
          completed: false
        })

      assert %{
               "id" => ^id,
               "text" => "some updated text",
               "completed" => false,
               "created_at" => _,
               "updated_at" => _
             } = json_response(conn, 200)
    end

    test "renders todo when only text field is informed", %{
      conn: conn,
      todo: %Todo{id: id} = todo
    } do
      conn = put(conn, Routes.todo_path(conn, :update, todo), %{text: "some updated text"})

      assert %{
               "id" => ^id,
               "text" => "some updated text",
               "completed" => true,
               "created_at" => _,
               "updated_at" => _
             } = json_response(conn, 200)
    end

    test "renders error when text field is not informed", %{
      conn: conn,
      todo: %Todo{id: id} = todo
    } do
      conn = put(conn, Routes.todo_path(conn, :update, todo), %{id: id, text: nil})

      assert %{"message" => "Text field not informed!"} = json_response(conn, 412)
    end

    test "renders error when text field is already informed", %{conn: conn, todo: todo} do
      post(conn, Routes.todo_path(conn, :create), %{text: @default_text})
      conn = put(conn, Routes.todo_path(conn, :update, todo), %{text: @default_text})

      assert %{
               "message" => "The todo '#{@default_text}' already exists!"
             } == json_response(conn, 412)
    end

    test "renders error when todo is not found", %{conn: conn, todo: todo} do
      conn =
        put(conn, Routes.todo_path(conn, :update, %Todo{id: @id_todo_nonexistent}), %{
          text: todo.text,
          completed: todo.completed
        })

      assert %{
               "message" => "Todo not found with id #{@id_todo_nonexistent}!"
             } == json_response(conn, 404)
    end
  end

  describe "delete todo" do
    setup [:create_todo]

    test "deletes chosen todo", %{conn: conn, todo: todo} do
      conn = delete(conn, Routes.todo_path(conn, :delete, todo))
      assert response(conn, 204)

      conn = get(conn, Routes.todo_path(conn, :show, todo))
      assert 404 == conn.status
    end

    test "renders error when todo is not found", %{conn: conn} do
      conn = delete(conn, Routes.todo_path(conn, :delete, %Todo{id: @id_todo_nonexistent}))

      assert %{
               "message" => "Todo not found with id #{@id_todo_nonexistent}!"
             } == json_response(conn, 404)
    end
  end

  defp create_todos(_) do
    Enum.each(1..5, fn _ -> todo_fixture() end)
    :ok
  end

  defp create_todo(_) do
    todo = todo_fixture()
    %{todo: todo}
  end
end
