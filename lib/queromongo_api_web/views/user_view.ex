defmodule QueroApiWeb.UserView do
  use QueromongoApiWeb, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("session.json", %{user: user, token: token}) do
    %{
      status: "ok",
      data: %{
        email: user.email,
        token: token
      }
    }
  end

  def render("user.json", %{user: user}) do
    id = BSON.ObjectId.encode!(user["_id"])
    %{id: id, email: user["email"], password: user["password"]}
  end
end
