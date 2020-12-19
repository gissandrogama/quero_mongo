defmodule QueromongoApiWeb.OffersController do
  use QueromongoApiWeb, :controller

  def index(conn, params) do
    price_discount = params["price_discount"]

    order_by =
      (price_discount == nil && []) ||
        [sort: %{price_with_discount: price_discount |> String.to_integer()}]

    params =
      params
      |> Map.delete("price_discount")

    response =
      Mongo.find(:mongo, "offers", params, order_by)
      |> Enum.to_list()
      |> Enum.map(&Map.delete(&1, "_id"))

    conn
    |> json(response)
  end
end
