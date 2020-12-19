defmodule Mix.Tasks.Offers do
  @moduledoc """
  module that has function generates the collection of offers and inserts in the mongo database.
  """
  use Mix.Task

  @spec run(any) :: nil | Mongo.InsertManyResult.t()
  def run(_) do
    Application.ensure_all_started(:queromongo_api)

    offers =
      "db.json"
      |> File.read!()
      |> Jason.decode!()

    Mongo.insert_many!(:mongo, "offers", offers)
  end
end
