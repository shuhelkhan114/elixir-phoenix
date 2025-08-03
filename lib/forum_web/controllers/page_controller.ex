defmodule ForumWeb.PageController do
  use ForumWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def user(conn, _params) do
    users = [
      %{ id: 1, name: "Shuhel", email: "shuhel.khan114@gmail.com" },
      %{ id: 2, name: "Alice", email: "alice@gmail.com" },
      %{ id: 3, name: "Aleena", email: "aleena@gmail.com" }
    ]
    json(conn, %{users: users})
  end
end
