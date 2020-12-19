defmodule QueromongoApiWeb.Guardian do
  @moduledoc """
  This use JWT for authetication
  """
  use Guardian, otp_app: :queromongo_api

  def subject_for_token(resource, _claims) do
    sub = to_string(resource.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    resource = QueromongoApi.Users.get_user(id)
    {:ok, resource}
  end
end
