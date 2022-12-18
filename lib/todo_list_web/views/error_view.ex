defmodule TodoListWeb.ErrorView do
  use TodoListWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end
  def render("404.json", %{conn: conn}) do
    %{message: "Todo not found with id #{conn.params["id"]}!"}
  end

  def render("text_already_exists.json", %{conn: conn}) do
    %{message: "The todo '#{conn.body_params["text"]}' already exists!"}
  end

  def render("412.json", _assigns) do
    %{message: "Text field not informed!"}
  end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    %{message: Phoenix.Controller.status_message_from_template(template)}
  end
end
