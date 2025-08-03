defmodule ForumWeb.PostController do
  use ForumWeb, :controller

  alias Forum.Posts
  alias Forum.Accounts
  alias Forum.Posts.Post

  action_fallback ForumWeb.FallbackController

  def index(conn, _params) do
    posts = Posts.list_posts()
    render(conn, :index, posts: posts)
  end

  def create(conn, %{"post" => post_params}) do
    user_id = Map.get(post_params, "user_id")
    IO.inspect(user_id, label: "user id")

    case Accounts.get_user(user_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User with ID #{user_id} not found"})

      _user ->
        with {:ok, %Post{} = post} <- Posts.create_post(post_params) do
          conn
          |> put_status(:created)
          |> put_resp_header("location", ~p"/api/posts/#{post}")
          |> render(:show, post: post)
        end
    end
  end

  def show(conn, %{"id" => id}) do
    post = Posts.get_post!(id)
    render(conn, :show, post: post)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Posts.get_post!(id)

    with {:ok, %Post{} = post} <- Posts.update_post(post, post_params) do
      render(conn, :show, post: post)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Posts.get_post!(id)

    with {:ok, %Post{}} <- Posts.delete_post(post) do
      send_resp(conn, :no_content, "")
    end
  end
end
