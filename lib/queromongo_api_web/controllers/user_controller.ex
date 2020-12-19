defmodule QueromongoApiWeb.UserController do
  use QueromongoApiWeb, :controller

  alias QueromongoApi.User

  def create(conn, %{"email" => email, "password" => password}) do
    params = %{email: email, password: password}

    case User.run(params) do
      {:error, message} ->
        conn
        |> put_status(401)
        |> json(%{status: message})

      {:ok, user} ->
        conn
        |> put_status(:created)
        |> json(user)
    end
  end

  def show(conn, %{"id" => id}) do
    id = id |> Jason.decode!() |> BSON.ObjectId.decode!()

    user =
      Mongo.find(:mongo, "users", %{"_id" => id})
      |> Enum.to_list()
      |> List.first()

    user_map = %{"id" => BSON.ObjectId.encode!(user["_id"]), "email" => user["email"], "password" => user["password"]}

    conn
    |> json(user_map)
  end
end
