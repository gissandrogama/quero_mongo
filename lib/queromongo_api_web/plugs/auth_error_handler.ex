defmodule QueromongoApiWeb.AuthErrorHandler do
  @moduledoc """
  The error handler is a module that implements an auth_error function
  """
  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, _reason}, _opts) do
    body = Phoenix.json_library().encode!(%{message: to_string(type)})

    conn
    |> put_resp_content_type("aplication/json")
    |> send_resp(401, body)
  end
end
