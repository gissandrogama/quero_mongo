defmodule QueromongoApiWeb.CoursesController do
  use QueromongoApiWeb, :controller

  def index(conn, params) do
    response =
      Mongo.find(:mongo, "courses", params)
      |> Enum.to_list()
      |> Enum.map(&Map.delete(&1, "_id"))

    conn
    |> json(response)
  end
end
