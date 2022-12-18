defmodule TodoListWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use TodoListWeb, :controller

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(TodoListWeb.ErrorView)
    |> render(:"404")
  end

  def call(
        conn,
        {:error,
         %Ecto.Changeset{
           errors: [
             text:
               {"has already been taken",
                [constraint: :unique, constraint_name: "todos_text_index"]}
           ]
         }}
      ) do
    conn
    |> put_status(:precondition_failed)
    |> put_view(TodoListWeb.ErrorView)
    |> render(:text_already_exists)
  end

  def call(conn, {:error, %Ecto.Changeset{}}) do
    conn
    |> put_status(:precondition_failed)
    |> put_view(TodoListWeb.ErrorView)
    |> render(:"412")
  end
end
