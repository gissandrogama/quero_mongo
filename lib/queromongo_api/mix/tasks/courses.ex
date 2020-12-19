defmodule Mix.Tasks.Courses do
  use Mix.Task


  def run(_)  do
    Application.ensure_all_started(:queromongo_api)
    courses =
      "db.json"
      |> File.read!()
      |> Jason.decode!()
      |> Enum.map(fn offer ->
        offer["course"]
        |> Map.put("university", offer["university"])
        |> Map.put("campus", offer["campus"])
      end)
    Mongo.insert_many!(:mongo, "courses", courses)
  end
end
